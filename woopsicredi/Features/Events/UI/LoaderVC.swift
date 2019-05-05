//
//  LoaderVC.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import UIKit

class LoaderVC: UIViewController {
    
    let baseWindow = UIApplication.shared.keyWindow
    let cornerRadios:CGFloat = 3
    var backgroundView,containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupContainerView()
        setupLoadingScreen()
    }
    
    private func setupLoadingScreen() {
        let loader = UIActivityIndicatorView(style: .whiteLarge)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = WSColorPalette.mediumGreen
        loader.startAnimating()
        
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.font = WSFont.FontTypes.regular.font(withSize: 20)
        labelTitle.textAlignment = .center
        labelTitle.textColor = WSColorPalette.fontColor
        labelTitle.text = "Aguarde"
        
        containerView.addSubview(loader)
        containerView.addSubview(labelTitle)
        
        let views : [String:Any] = ["loader":loader, "labelTitle":labelTitle]
        var allConstraints = [NSLayoutConstraint]()
        
        allConstraints += "V:|-32-[loader(30)]-24-[labelTitle]-32-|".toConstraints(withViews: views)
        allConstraints += "[loader(30)]".toConstraints(withViews: views)
        allConstraints += "|-32-[labelTitle]-32-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let loaderCenterXConstraint = NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(loaderCenterXConstraint)
        
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = cornerRadios
        view.addSubview(containerView)
        
        let views: [String: Any] = [
            "containerView": containerView!]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:[containerView]".toConstraints(withViews: views)
        allConstraints += "[containerView]".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let centerYConstraint = NSLayoutConstraint(item: containerView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(centerYConstraint)
        
        let centerXConstraint = NSLayoutConstraint(item: containerView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(centerXConstraint)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView(frame: view.frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        view.addSubview(backgroundView)
        
        let views: [String: Any] = [
            "backgroundView": backgroundView!]
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|[backgroundView]|".toConstraints(withViews: views)
        allConstraints += "|[backgroundView]|".toConstraints(withViews: views)
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func hide() {
        containerView.removeFromSuperview()
        backgroundView.removeFromSuperview()
        removeFromParent()
    }
    
}

