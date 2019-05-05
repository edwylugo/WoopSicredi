//
//  DateExtensionTests.swift
//  woopsicrediTests
//
//  Created by Edwy Lugo on 04/05/19.
//

import XCTest
@testable import woopsicredi

class DateExtensionTests: XCTestCase {
    
    func testDateFormatter() {
        let dateFormatValue = "dd/MM/yyyy - HH:mm"
        
        let date = Date(timeIntervalSince1970:123456789)
        
        let expected = "29/11/1973 - 18:33"
        let formattedDate = date.toFormat(dateFormatValue)
        
        XCTAssertEqual(formattedDate, expected)
    }
    
}
