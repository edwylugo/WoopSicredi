//
//  WSColorPalette.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import UIKit

class WSColorPalette {
    
    static var lightGreen: UIColor {
        get {
            return UIColor(red: 100/255, green: 200/255, blue: 50/255, alpha: 1)
        }
    }
    
    static var mediumGreen: UIColor {
        get {
            return UIColor(red: 20/255, green: 110/255, blue: 55/255, alpha: 1)
        }
    }
    
    static var darkGreen: UIColor {
        get {
            return UIColor(red: 90/255, green: 100/255, blue: 91/255, alpha: 1)
        }
    }
    
    static var fontColor: UIColor {
        get {
            return UIColor(red: 58/255, green: 68/255, blue: 58/255, alpha: 1)
        }
    }
    
    static var errorRedColor: UIColor {
        get {
            return UIColor(red: 205/255, green: 0/255, blue: 1/255, alpha: 1)
        }
    }
}

