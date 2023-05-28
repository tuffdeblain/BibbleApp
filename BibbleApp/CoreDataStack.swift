//
//  CoreDataStack.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import Foundation
import CoreData

struct CoreDataStack {
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BibbleApp") // Use the name of your CoreData model
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
}
