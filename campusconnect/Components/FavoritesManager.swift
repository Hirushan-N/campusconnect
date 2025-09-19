import Foundation
import SwiftUI
import CoreData

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    // public, unchanged
    @Published var favoriteCommunityIds: Set<String> = []
    @Published var favoriteEventIds: Set<String> = []

    private let communityKey = "favoriteCommunityIds"
    private let eventKey = "favoriteEventIds"
    private let ctx: NSManagedObjectContext

    private init() {
        ctx = CoreDataStack.shared.container.viewContext
        migrateUserDefaultsIfNeeded()
        reloadFromStore()
    }

    // MARK: - Public API (unchanged signatures)

    func addCommunityToFavorites(_ community: Community) {
        upsertFavorite(key: community.id.uuidString, kind: "community")
        reloadFromStore()
    }

    func addCommunityToFavoritesByName(_ communityName: String) {
        upsertFavorite(key: communityName, kind: "community")
        reloadFromStore()
    }

    func removeCommunityFromFavorites(_ communityIdOrName: String) {
        deleteFavorite(key: communityIdOrName, kind: "community")
        reloadFromStore()
    }

    func isCommunityFavorited(_ communityIdOrName: String) -> Bool {
        return hasFavorite(key: communityIdOrName, kind: "community")
    }

    func addEventToFavorites(_ event: Event) {
        upsertFavorite(key: event.id.uuidString, kind: "event")
        reloadFromStore()
    }

    func addEventToFavoritesByName(_ eventTitle: String) {
        upsertFavorite(key: eventTitle, kind: "event")
        reloadFromStore()
    }

    func removeEventFromFavorites(_ eventIdOrTitle: String) {
        deleteFavorite(key: eventIdOrTitle, kind: "event")
        reloadFromStore()
    }

    func isEventFavorited(_ eventIdOrTitle: String) -> Bool {
        return hasFavorite(key: eventIdOrTitle, kind: "event")
    }

    func getFavoriteCommunities(from allCommunities: [Community]) -> [Community] {
        return allCommunities.filter { favoriteCommunityIds.contains($0.name) || favoriteCommunityIds.contains($0.id.uuidString) }
    }

    func getFavoriteEvents(from allEvents: [Event]) -> [Event] {
        return allEvents.filter { favoriteEventIds.contains($0.title) || favoriteEventIds.contains($0.id.uuidString) }
    }

    // MARK: - Core Data helpers

    private func upsertFavorite(key: String, kind: String) {
        if hasFavorite(key: key, kind: kind) { return }
        let fav = Favorite(context: ctx)
        fav.key = key
        fav.kind = kind
        save()
    }

    private func deleteFavorite(key: String, kind: String) {
        let req: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        req.predicate = NSPredicate(format: "key == %@ AND kind == %@", key, kind)
        if let matches = try? ctx.fetch(req) {
            matches.forEach(ctx.delete)
            save()
        }
    }

    private func hasFavorite(key: String, kind: String) -> Bool {
        let req: NSFetchRequest<NSFetchRequestResult> = Favorite.fetchRequest()
        req.predicate = NSPredicate(format: "key == %@ AND kind == %@", key, kind)
        req.fetchLimit = 1
        do {
            let count = try ctx.count(for: req)
            return count > 0
        } catch {
            return false
        }
    }

    private func reloadFromStore() {
        let req: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        if let all = try? ctx.fetch(req) {
            let communities = all.filter { $0.kind == "community" }.map { $0.key }
            let events = all.filter { $0.kind == "event" }.map { $0.key }
            DispatchQueue.main.async {
                self.favoriteCommunityIds = Set(communities)
                self.favoriteEventIds = Set(events)
            }
        }
    }

    private func save() {
        if ctx.hasChanges {
            do { try ctx.save() } catch {
                #if DEBUG
                print("CoreData save error: \(error)")
                #endif
            }
        }
    }

    // MARK: - One-time migration from UserDefaults

    private func migrateUserDefaultsIfNeeded() {
        let migratedKey = "favorites_migrated_to_coredata"
        let already = UserDefaults.standard.bool(forKey: migratedKey)
        guard !already else { return }

        if let oldCommunities = UserDefaults.standard.array(forKey: communityKey) as? [String] {
            oldCommunities.forEach { upsertFavorite(key: $0, kind: "community") }
        }
        if let oldEvents = UserDefaults.standard.array(forKey: eventKey) as? [String] {
            oldEvents.forEach { upsertFavorite(key: $0, kind: "event") }
        }

        save()
        UserDefaults.standard.set(true, forKey: migratedKey)
    }
}

// Convenience typed fetchRequest
extension Favorite {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        NSFetchRequest<Favorite>(entityName: "Favorite")
    }
}
