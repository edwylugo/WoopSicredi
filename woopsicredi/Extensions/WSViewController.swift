//
//  WSViewController.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import UIKit

class WSViewController : UIViewController {
    
    var loaderVC: LoaderVC!
    
    public func setupLoader() {
        loaderVC = LoaderVC()
        guard let loaderView = loaderVC.view else { return }
        addChild(loaderVC)
        view.addSubview(loaderView)
    }
    
    public func hideLoader() {
        loaderVC.hide()
        view.sendSubviewToBack(loaderVC.view)
    }
    
}
