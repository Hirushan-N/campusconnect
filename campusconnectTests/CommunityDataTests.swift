//
//  CommunityDataTests.swift
//  campusconnectTests
//
//

import XCTest
@testable import campusconnect

final class CommunityDataTests: XCTestCase {
    
    func testPopularCommunitiesAreLoaded() {
        XCTAssertFalse(popularCommunities.isEmpty, "Popular communities should not be empty")
    }
    
    func testEachCommunityHasLeader() {
        for community in popularCommunities {
            XCTAssertFalse(community.leader.name.isEmpty, "Each community must have a leader")
        }
    }
    
    func testCommunityMemberCountIncludesLeader() {
        for community in popularCommunities {
            XCTAssertEqual(community.totalMembers, community.members.count + 1, "Total members should include leader")
        }
    }
    
    func testCommunitySkillsAreNotEmpty() {
        for community in popularCommunities {
            XCTAssertFalse(community.skills.isEmpty, "Each community should have at least one skill")
        }
    }
}
