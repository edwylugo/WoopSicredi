//
//  EventListVMTests.swift
//  woopsicrediTests
//
//  Created by Edwy Lugo on 04/05/19.
//

import XCTest
@testable import woopsicredi

class EventListVMTests: XCTestCase {
    
    func testRequiredData() {
        let provider = EventsService()
        let model = EventsListVM(provider: provider)
        let expectation = self.expectation(description: "requesting")
        model.fetchEvents { (error, model) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertNotNil(model.fetchEventsResponse, "Response is nil")
        XCTAssertNotNil(model.fetchEventsResponse?.events, "Events doesnt exists")
        if let entries = model.fetchEventsResponse?.events {
            for entry in entries {
                //Assert all data used at cell model
                XCTAssertNotNil(entry.id, "Id doesnt exists")
                XCTAssertNotNil(entry.title, "Title doesnt exists")
                XCTAssertNotNil(entry.date, "Date doesnt exists")
                XCTAssertNotNil(entry.imageURL, "Image doesnt exists")
                XCTAssertNotNil(entry.price, "Price doesnt exists")
            }
        }
    }
}

