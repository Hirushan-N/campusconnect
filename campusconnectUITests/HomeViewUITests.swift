//
//  HomeViewUITests.swift
//  campusconnectUITests
//
//

import XCTest

final class HomeViewUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFindCommunitiesButtonNavigatesCorrectly() {
        let findCommunitiesButton = app.staticTexts["Find Communities"]
        XCTAssertTrue(findCommunitiesButton.exists)
        findCommunitiesButton.tap()

        let navBar = app.navigationBars["Find Communities"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }

    func testFindEventsButtonNavigatesCorrectly() {
        let findEventsButton = app.staticTexts["Find Events"]
        XCTAssertTrue(findEventsButton.exists)
        findEventsButton.tap()

        let navBar = app.navigationBars["Events"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }
}
