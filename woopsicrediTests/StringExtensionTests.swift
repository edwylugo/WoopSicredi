//
//  StringExtensionTests.swift
//  woopsicrediTests
//
//  Created by Edwy Lugo on 04/05/19.
//

import XCTest
@testable import woopsicredi

class StringExtensionTests: XCTestCase {
    
    func testValidEmail() {
        let email = "edwy.rs@gmail.com"
        XCTAssert(email.isValidEmail(), "Valid Email")
    }
    
    func testInvalidEmail() {
        let email = "edwy.com"
        XCTAssert(email.isValidEmail() == false , "Invalid Email")
    }
    
}
