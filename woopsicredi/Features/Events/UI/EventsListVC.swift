//
//  EventsListVC.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import UIKit

protocol EventsListCoordinatorDelegate {
    func didSelectEvent(eventID: String)
}

class EventsListVC: WSViewController {
    
    var model: EventsListVM!
    var tableView: UITableView!
    var coordinator: EventsCoordinator!
    var delegate: EventsListCoordinatorDelegate!
    var alertVC: AlertVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        fetchEvents()
    }
    
    private func fetchEvents() {
        setupLoader()
        model.fetchEvents { [weak self] (error, model) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoader()
            if error != nil {
                weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
            } else {
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    private func setupTryAgain(errorDesc: String?) {
        alertVC = AlertVC()
        let content = GenericPopUpContent(imageName: model.errorIconName, color: WSColorPalette.fontColor, title: model.defaultTitle, desc: errorDesc ?? model.defaultErrorMessage, buttonTitle: model.tryAgainTitle, cancelBlock: didCancelRetry) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
            weakSelf.setupLoader()
            weakSelf.model.fetchEvents { [weak self] (error, model) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoader()
                if error != nil {
                    weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
                } else {
                    weakSelf.tableView.reloadData()
                }
            }
        }
        alertVC.content = content
        guard let errorAlertView = alertVC.view else { return }
        addChild(alertVC)
        view.addSubview(errorAlertView)
    }
    
    private func didCancelRetry() {
        view.sendSubviewToBack(alertVC.view)
        fetchEvents()
    }
}

extension EventsListVC {
    //MARK: VIEW CODE
    private func viewSetup() {
        view.backgroundColor = UIColor.white
        title = model.title
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        tableView.register(EventsListTableViewCell.self, forCellReuseIdentifier: model.cellReuseIdendifier)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let views : [String:UIView] = ["tableView":tableView]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|[tableView]|".toConstraints(withViews: views)
        allConstraints += "|[tableView]|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
    }
}

extension EventsListVC : UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.entries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = model.entries[indexPath.row]
        delegate.didSelectEvent(eventID: content.id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReuseIdendifier) as! EventsListTableViewCell
        let content = model.entries[indexPath.row]
        cell.content = content
        return cell
    }
}
