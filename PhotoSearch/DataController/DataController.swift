//
//  DataController.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Main", managedObjectModel: Self.model)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading stroe: \(error.localizedDescription)")
            }

            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: PhotoCollection) {
        container.viewContext.delete(object)
        save()
    }
}
