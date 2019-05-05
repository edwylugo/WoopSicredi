//
//  AlertVC.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import UIKit

class AlertVC: UIViewController {
    
    let cornerRadios:CGFloat = 3
    var backgroundView: UIView!
    var containerView: UIView!
    var alertImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var retryButton: UIButton!
    var content: GenericPopUpContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.clear
        setupBackgroundView()
        setupContainerView()
        setupContent()
        setupRetry()
    }
    
    private func setupContent() {
        alertImageView = UIImageView()
        alertImageView.translatesAutoresizingMaskIntoConstraints = false
        alertImageView.tintColor = content.color
        
        if let img = UIImage(named: content.imageName) {
            alertImageView.image = img.withRenderingMode(.alwaysTemplate)
        }
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = content.color
        titleLabel.text = content.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = WSColorPalette.fontColor
        descriptionLabel.text = content.desc
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = WSFont.FontTypes.regular.font(withSize: 12)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        containerView.addSubview(alertImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        let views: [String: UIView] = [
            "alertImageView": alertImageView,
            "titleLabel": titleLabel,
            "descriptionLabel": descriptionLabel]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        allConstraints += "V:|-20-[alertImageView(30)]".toConstraints(withViews: views)
        allConstraints += "[alertImageView(30)]".toConstraints(withViews: views)
        allConstraints += "V:[alertImageView]-8-[titleLabel]".toConstraints(withViews: views)
        allConstraints += "|-25-[titleLabel]-25-|".toConstraints(withViews: views)
        allConstraints += "V:[titleLabel]-16-[descriptionLabel]".toConstraints(withViews: views)
        allConstraints += "|-25-[descriptionLabel]-25-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let centerXConstraint = NSLayoutConstraint(item: alertImageView!, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        containerView.addConstraint(centerXConstraint)
    }
    
    private func setupRetry() {
        retryButton = UIButton()
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.backgroundColor = WSColorPalette.darkGreen
        retryButton.layer.cornerRadius = cornerRadios
        retryButton.titleLabel?.font = WSFont.FontTypes.regular.font(withSize: 16)
        retryButton.setTitle(content.buttonTitle, for: .normal)
        retryButton.setTitleColor(UIColor.white, for: .normal)
        retryButton.addTarget(self, action: #selector(didNext), for: .touchUpInside)
        
        containerView.addSubview(retryButton)
        
        let views: [String: UIView] = [
            "retryButton": retryButton,
            "descriptionLabel": descriptionLabel]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:[descriptionLabel]-20-[retryButton(40)]-24-|".toConstraints(withViews: views)
        allConstraints += "|-16-[retryButton]-16-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView(frame: view.frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backgroundView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backgroundView.addGestureRecognizer(tap)
        
        view.addSubview(backgroundView)
        
        let views: [String: UIView] = [
            "backgroundView": backgroundView]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|[backgroundView]|".toConstraints(withViews: views)
        allConstraints += "|[backgroundView]|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = cornerRadios
        view.addSubview(containerView)
        
        let views: [String: UIView] = [
            "containerView": containerView]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:[containerView]".toConstraints(withViews: views)
        allConstraints += "|-30-[containerView]-30-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let centerYConstraint = NSLayoutConstraint(item: containerView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(centerYConstraint)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        content.cancelBlock?()
        hide()
    }
    
    func hide() {
        containerView.removeFromSuperview()
        backgroundView.removeFromSuperview()
        removeFromParent()
    }
    
    @objc func didNext() {
        content.buttonBlock?()
        hide()
    }
}

struct GenericPopUpContent {
    let imageName : String
    let color: UIColor
    let title: String
    let desc: String
    let buttonTitle: String
    let cancelBlock: (() -> Void)?
    let buttonBlock: (() -> Void)?
}
