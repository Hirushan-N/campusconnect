//
//  RegisterToCommunityFormTests.swift
//  campusconnectTests
//
//

import XCTest
@testable import campusconnect

final class RegisterToCommunityFormTests: XCTestCase {
    
    func testValidSkillSelection() {
        let selectedSkills = ["Swift", "Python"]
        XCTAssertTrue(selectedSkills.contains("Swift"), "Swift should be in selected skills")
        XCTAssertFalse(selectedSkills.contains("JavaScript"), "JavaScript is not in predefined skills")
    }
}
