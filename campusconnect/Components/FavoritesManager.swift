//
//  FavoritesManager.swift
//  campusconnect
//
//  Created by Gihan Sudeepa on 2025-03-08.
//

import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteCommunityIds: Set<String> = []
    @Published var favoriteEventIds: Set<String> = []
    
    private let communityKey = "favoriteCommunityIds"
    private let eventKey = "favoriteEventIds"
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - Community Favorites
    
    func addCommunityToFavorites(_ community: Community) {
        print("❤️ Adding community to favorites: \(community.name) with ID: \(community.id.uuidString)")
        favoriteCommunityIds.insert(community.id.uuidString)
        saveFavorites()
        print("📝 Current favorite community IDs: \(favoriteCommunityIds)")
    }
    
    func addCommunityToFavoritesByName(_ communityName: String) {
        print("❤️ Adding community to favorites by name: \(communityName)")
        favoriteCommunityIds.insert(communityName)
        saveFavorites()
        print("📝 Current favorite community IDs: \(favoriteCommunityIds)")
    }
    
    func removeCommunityFromFavorites(_ communityId: String) {
        favoriteCommunityIds.remove(communityId)
        saveFavorites()
    }
    
    func isCommunityFavorited(_ communityId: String) -> Bool {
        let isFavorited = favoriteCommunityIds.contains(communityId)
        print("🔍 Checking if community \(communityId) is favorited: \(isFavorited)")
        return isFavorited
    }
    
    // MARK: - Event Favorites
    
    func addEventToFavorites(_ event: Event) {
        favoriteEventIds.insert(event.id.uuidString)
        saveFavorites()
    }
    
    func addEventToFavoritesByName(_ eventTitle: String) {
        print("❤️ Adding event to favorites by title: \(eventTitle)")
        favoriteEventIds.insert(eventTitle)
        saveFavorites()
        print("📝 Current favorite event IDs: \(favoriteEventIds)")
    }
    
    func removeEventFromFavorites(_ eventId: String) {
        favoriteEventIds.remove(eventId)
        saveFavorites()
    }
    
    func isEventFavorited(_ eventId: String) -> Bool {
        return favoriteEventIds.contains(eventId)
    }
    
    // MARK: - Persistence
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCommunityIds), forKey: communityKey)
        UserDefaults.standard.set(Array(favoriteEventIds), forKey: eventKey)
    }
    
    private func loadFavorites() {
        if let communityIds = UserDefaults.standard.array(forKey: communityKey) as? [String] {
            favoriteCommunityIds = Set(communityIds)
        }
        if let eventIds = UserDefaults.standard.array(forKey: eventKey) as? [String] {
            favoriteEventIds = Set(eventIds)
        }
    }
    
    // MARK: - Get Favorites Data
    
    func getFavoriteCommunities(from allCommunities: [Community]) -> [Community] {
        return allCommunities.filter { favoriteCommunityIds.contains($0.name) }
    }
    
    func getFavoriteEvents(from allEvents: [Event]) -> [Event] {
        return allEvents.filter { favoriteEventIds.contains($0.title) }
    }
}