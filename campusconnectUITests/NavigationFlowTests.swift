//
//  NavigationFlowTests.swift
//  campusconnectUITests
//
//

import XCTest

final class NavigationFlowTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigateToCommunityDetailAndJoin() {
        app.staticTexts["Find Communities"].tap()

        // Wait for grid to load and tap first community
        let communityCells = app.scrollViews.otherElements.staticTexts
        XCTAssertTrue(communityCells.firstMatch.waitForExistence(timeout: 2))
        communityCells.firstMatch.tap()

        // Join button
        let joinButton = app.buttons["Join Community"]
        XCTAssertTrue(joinButton.waitForExistence(timeout: 2))
        joinButton.tap()

        // Check for the registration form
        let navTitle = app.navigationBars["Member Application"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 2))
    }

    func testNavigateToEventDetail() {
        app.staticTexts["Find Events"].tap()

        let firstEvent = app.scrollViews.otherElements.staticTexts.element(boundBy: 0)
        XCTAssertTrue(firstEvent.waitForExistence(timeout: 2))
        firstEvent.tap()

        let goToEventLocationButton = app.buttons["Go to Event Location"]
        XCTAssertTrue(goToEventLocationButton.exists)
    }
}
