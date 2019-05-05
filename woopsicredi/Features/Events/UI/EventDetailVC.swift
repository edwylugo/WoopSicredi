//
//  EventDetailVC.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import UIKit

protocol EventDetailsCoordinatorDelegate {
    func didAskForCheckIn(eventID: String)
}

class EventDetailVC: WSViewController {
    
    var model: EventDetailVM!
    var coordinator: EventsCoordinator!
    var shouldUpdateDetails = false
    var delegate: EventDetailsCoordinatorDelegate!
    var alertVC: AlertVC!
    var scrollView: UIScrollView!
    var titleLabel,descriptionLabel,peopleLabel,voucherLabel : UILabel!
    var pictureImageView: UIImageView!
    var peopleNumberButton,voucherNumberButton,checkInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        fetchDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldUpdateDetails {
            fetchDetails()
            shouldUpdateDetails = false
        }
    }
    
    private func fetchDetails() {
        setupLoader()
        model.fetchEventDetails { [weak self] (error, model) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoader()
            if error != nil {
                weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
            } else {
                weakSelf.setupContent()
            }
        }
    }
    
    private func setupTryAgain(errorDesc: String?) {
        alertVC = AlertVC()
        let cancelRetryBlock = { [ weak self ] in
            guard let weakSelf = self else { return }
            weakSelf.coordinator.navigationController.popViewController(animated: true)
        }
        let content = GenericPopUpContent(imageName: model.errorIconName, color: WSColorPalette.fontColor, title: model.defaultTitle, desc: errorDesc ?? "Erro desconhecido", buttonTitle: model.notImplementedButtonTitle, cancelBlock: cancelRetryBlock) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
            weakSelf.setupLoader()
            weakSelf.model.fetchEventDetails { [weak self] (error, model) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoader()
                if error != nil {
                    weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
                } else {
                    weakSelf.setupContent()
                }
            }
        }
        alertVC.content = content
        guard let errorAlertView = alertVC.view else { return }
        addChild(alertVC)
        view.addSubview(errorAlertView)
    }
}

extension EventDetailVC {
    //MARK: Actions
    
    @objc func didTapPeopleButton() {
        showNotImplementedFeat(featTitle: "Pessoas", featDesc: "Desenvolver tela de lista de pessoas")
    }
    
    @objc func didTapVoucherButton() {
        showNotImplementedFeat(featTitle: "Voucher", featDesc: "Desenvolver tela de lista de cupons")
    }
    
    @objc func didTapCheckInButton() {
        delegate.didAskForCheckIn(eventID: model.currentEventID)
    }
    
    private func showNotImplementedFeat(featTitle: String, featDesc: String) {
        alertVC = AlertVC()
        let content = GenericPopUpContent(imageName: model.errorIconName, color: WSColorPalette.fontColor, title: featTitle, desc: featDesc, buttonTitle: model.tryAgainTitle, cancelBlock: nil) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
        }
        alertVC.content = content
        guard let errorAlertView = alertVC.view else { return }
        addChild(alertVC)
        view.addSubview(errorAlertView)
    }
}


extension EventDetailVC {
    //MARK: VIEW CODE
    private func viewSetup() {
        view.backgroundColor = UIColor.white
        title = model.title
        setupScrollView()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        
        let views : [String:UIView] = ["scrollView":scrollView]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|[scrollView]|".toConstraints(withViews: views)
        allConstraints += "|[scrollView]|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func setupContent() {
        let maxContentWidth = view.frame.width - 32
        let unit = maxContentWidth / 16
        let maxPictureHeight = unit * 9
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = WSFont.FontTypes.bold.font(withSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textColor = WSColorPalette.fontColor
        titleLabel.text = model.fetchEventDetails?.eventData?.title
        
        pictureImageView = UIImageView()
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        if let urlString = model.fetchEventDetails?.eventData?.imageURL {
            let url = URL(string: urlString)
            pictureImageView.kf.setImage(with: url)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        descriptionLabel.textColor = WSColorPalette.fontColor
        descriptionLabel.text = model.fetchEventDetails?.eventData?.description
        
        peopleNumberButton = UIButton()
        peopleNumberButton.translatesAutoresizingMaskIntoConstraints = false
        let countPeople = model.fetchEventDetails?.eventData?.people?.count ?? 0
        peopleNumberButton.setTitle(String(countPeople), for: .normal)
        peopleNumberButton.layer.cornerRadius = 25
        peopleNumberButton.layer.masksToBounds = true
        peopleNumberButton.backgroundColor = WSColorPalette.mediumGreen
        peopleNumberButton.addTarget(self, action: #selector(didTapPeopleButton), for: .touchUpInside)
        
        voucherNumberButton = UIButton()
        voucherNumberButton.translatesAutoresizingMaskIntoConstraints = false
        let countVoucher = model.fetchEventDetails?.eventData?.coupons?.count ?? 0
        voucherNumberButton.setTitle(String(countVoucher), for: .normal)
        voucherNumberButton.layer.cornerRadius = 25
        voucherNumberButton.layer.masksToBounds = true
        voucherNumberButton.backgroundColor = WSColorPalette.mediumGreen
        voucherNumberButton.addTarget(self, action: #selector(didTapVoucherButton), for: .touchUpInside)
        
        peopleLabel = UILabel()
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        peopleLabel.textAlignment = .center
        peopleLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        peopleLabel.textColor = WSColorPalette.fontColor
        peopleLabel.text = model.peopleLabelText
        
        voucherLabel = UILabel()
        voucherLabel.translatesAutoresizingMaskIntoConstraints = false
        voucherLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        voucherLabel.textAlignment = .center
        voucherLabel.textColor = WSColorPalette.fontColor
        voucherLabel.text = model.voucherLabelText
        
        checkInButton = UIButton()
        checkInButton.translatesAutoresizingMaskIntoConstraints = false
        checkInButton.backgroundColor = WSColorPalette.darkGreen
        checkInButton.layer.cornerRadius = 3
        checkInButton.titleLabel?.font = WSFont.FontTypes.regular.font(withSize: 16)
        checkInButton.setTitle(model.checkInTitle, for: .normal)
        checkInButton.setTitleColor(UIColor.white, for: .normal)
        checkInButton.addTarget(self, action: #selector(didTapCheckInButton), for: .touchUpInside)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(pictureImageView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(peopleLabel)
        scrollView.addSubview(voucherLabel)
        scrollView.addSubview(peopleNumberButton)
        scrollView.addSubview(voucherNumberButton)
        scrollView.addSubview(checkInButton)
        
        let views: [String: UIView] = ["titleLabel": titleLabel,
                                       "pictureImageView": pictureImageView,
                                       "descriptionLabel": descriptionLabel,
                                       "peopleNumberButton": peopleNumberButton,
                                       "voucherNumberButton": voucherNumberButton,
                                       "peopleLabel":peopleLabel,
                                       "voucherLabel":voucherLabel,
                                       "checkInButton":checkInButton]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|-32-[titleLabel]-24-[pictureImageView(\(maxPictureHeight))]-24-[descriptionLabel]-32-[peopleNumberButton(50)]-12-[peopleLabel]-24-[checkInButton(50)]-48-|".toConstraints(withViews: views)
        allConstraints += "V:[descriptionLabel]-32-[voucherNumberButton(50)]-12-[voucherLabel]-24-[checkInButton]-48-|".toConstraints(withViews: views)
        allConstraints += "|-16-[titleLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[pictureImageView(\(maxContentWidth))]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[descriptionLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[peopleLabel]-16-[voucherLabel(peopleLabel)]-16-|".toConstraints(withViews: views)
        allConstraints += "[peopleNumberButton(50)]".toConstraints(withViews: views)
        allConstraints += "[voucherNumberButton(50)]".toConstraints(withViews: views)
        allConstraints += "|-16-[checkInButton]-16-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let centerXConstraintPeopleNumberButton = NSLayoutConstraint(item: peopleNumberButton!, attribute: .centerX, relatedBy: .equal, toItem: peopleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        scrollView.addConstraint(centerXConstraintPeopleNumberButton)
        
        let centerXConstraintVoucherNumberButton = NSLayoutConstraint(item: voucherNumberButton!, attribute: .centerX, relatedBy: .equal, toItem: voucherLabel, attribute: .centerX, multiplier: 1, constant: 0)
        scrollView.addConstraint(centerXConstraintVoucherNumberButton)
    }
}
