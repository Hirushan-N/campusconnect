//
//  EventDataTests.swift
//  campusconnectTests
//
//

import XCTest
@testable import campusconnect

final class EventDataTests: XCTestCase {
    
    func testEventListIsNotEmpty() {
        XCTAssertFalse(sampleEvents.isEmpty, "Event list should not be empty")
    }
    
    func testEventHasTitleAndVenue() {
        for event in sampleEvents {
            XCTAssertFalse(event.title.isEmpty, "Event title should not be empty")
            XCTAssertFalse(event.venue.isEmpty, "Event venue should not be empty")
        }
    }
    
    func testEventCoordinatesValid() {
        for event in sampleEvents {
            XCTAssertGreaterThan(event.latitude, 0, "Latitude should be > 0")
            XCTAssertGreaterThan(event.longitude, 0, "Longitude should be > 0")
        }
    }
    
    func testEventTagsContainRelevantKeyword() {
        let event = sampleEvents[0]
        XCTAssertTrue(event.tags.contains { $0.lowercased().contains("culture") }, "Expected 'Culture' tag in first event")
    }
}

