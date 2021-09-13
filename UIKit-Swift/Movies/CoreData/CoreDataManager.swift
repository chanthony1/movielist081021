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
    
}
