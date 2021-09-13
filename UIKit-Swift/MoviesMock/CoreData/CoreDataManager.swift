//
//  CoreDataManager.swift
//  Movies
//
//  Created by Christian Quicano on 26/08/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Something went wrong")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAll() throws {
        // Get a reference to a NSPersistentStoreCoordinator
        let storeContainer = persistentContainer.persistentStoreCoordinator
        // Delete each existing persistent store
        for store in storeContainer.persistentStores {
            try storeContainer.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
        }
        // Re-create the persistent container
        persistentContainer = NSPersistentContainer(
            name: "MoviesModel" // the name of
            // a .xcdatamodeld file
        )
        // Calling loadPersistentStores will re-create the
        // persistent stores
        persistentContainer.loadPersistentStores {
            (store, error) in
            // Handle errors
        }
    }
}
