//
//  StoreManager.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/25/23.
//

import Foundation
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CRUD Methods
    // Create
    func saveTask(_ name: String, completion: (Tasker) -> Void) {
        let task = Tasker(context: context)
        task.name = name
        completion(task)
        saveContext()
    }

    // Retrive
    func fetchData(completion: (Result<[Tasker], Error>) -> Void) {
        let fetchRequest = Tasker.fetchRequest()
        do{
            let tasks = try context.fetch(fetchRequest)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Delete
    func delete(_ data: Tasker) {
        context.delete(data)
        saveContext()
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
