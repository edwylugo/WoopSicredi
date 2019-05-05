//
//  MoneyExtensionTests.swift
//  woopsicrediTests
//
//  Created by Edwy Lugo on 04/05/19.
//

import XCTest
@testable import woopsicredi

class MoneyExtensionTests: XCTestCase {
    
    func testMoneyFormat() {
        let value = 12.22
        let moneyFormattedValue = Money.format(fromDouble: value, withPrefix: true, valueIfNull: "---")
        let moneyExpectedFormattedValue = "R$  12,22"
        
        XCTAssertEqual(moneyFormattedValue, moneyExpectedFormattedValue)
    }
    
}
