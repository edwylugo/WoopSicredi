//
//  EventDetailVMTests.swift
//  woopsicrediTests
//
//  Created by Edwy Lugo on 04/05/19.
//

import XCTest
@testable import woopsicredi

class EventDetailVMTests: XCTestCase {
    
    func testRequiredData() {
        let provider = EventsService()
        let modelEventList = EventsListVM(provider: provider)
        let expectationFetchList = self.expectation(description: "requesting")
        modelEventList.fetchEvents { (error, model) in
            expectationFetchList.fulfill()
        }
        wait(for: [expectationFetchList], timeout: 30)
        if let firstEventID = modelEventList.fetchEventsResponse?.events?.first?.id {
            let expectationEventDetail = self.expectation(description: "requesting")
            let modelEventDetail = EventDetailVM(provider: provider, eventID: firstEventID)
            modelEventDetail.fetchEventDetails { (error, model) in
                expectationEventDetail.fulfill()
            }
            wait(for: [expectationEventDetail], timeout: 30)
            if let entry = modelEventDetail.fetchEventDetails?.eventData {
                XCTAssertNotNil(entry.title, "Title doesnt exists")
                XCTAssertNotNil(entry.imageURL, "Image doesnt exists")
                XCTAssertNotNil(entry.description, "Description doesnt exists")
                XCTAssertNotNil(entry.coupons, "Voucher doesnt exists")
                XCTAssertNotNil(entry.people, "People doesnt exists")
            }
        } else {
            XCTFail("Event is nil")
        }
    }
}

