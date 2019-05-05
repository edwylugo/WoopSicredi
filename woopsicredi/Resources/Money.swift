//
//  Money.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation

class Money {
    
    static func format(fromDouble value: Double?, withPrefix: Bool = true, valueIfNull: String = "---") -> String {
        guard let value = value else {
            return valueIfNull
        }
        let prefix: String = "R$"
        let price = NSNumber.init(floatLiteral: value)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        formatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale?
        
        let replacer = withPrefix ? "\(prefix) " : ""
        return formatter.string(from: price)!.replacingOccurrences(of: "R$", with: replacer)
    }
    
    
}
