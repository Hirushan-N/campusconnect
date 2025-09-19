import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private init() {
        let model = NSManagedObjectModel()
        let favorite = NSEntityDescription()
        favorite.name = "Favorite"
        favorite.managedObjectClassName = NSStringFromClass(Favorite.self)

        // Attributes
        let key = NSAttributeDescription()
        key.name = "key"
        key.attributeType = .stringAttributeType
        key.isOptional = false

        let kind = NSAttributeDescription()
        kind.name = "kind"
        kind.attributeType = .stringAttributeType
        kind.isOptional = false

        favorite.properties = [key, kind]
        favorite.uniquenessConstraints = [["key", "kind"]]

        model.entities = [favorite]

        container = NSPersistentContainer(name: "CampusConnect", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData load error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

// NSManagedObject subclass
@objc(Favorite)
final class Favorite: NSManagedObject {
    @NSManaged var key: String
    @NSManaged var kind: String
}
