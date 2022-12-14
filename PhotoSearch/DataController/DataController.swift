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

    static let preview: DataController = {
        let dataController = DataController()

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("fatal error loading preview, \(error.localizedDescription)")
        }

        return dataController
    }()

    func createSampleData() throws {
        let viewContext = container.viewContext

        for _ in 1...4 {
            let photoCollection = PhotoCollection(context: viewContext)
            photoCollection.id = UUID()
            photoCollection.title = "Example"
            photoCollection.date = Date.now
        }
        try viewContext.save()
    }

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
