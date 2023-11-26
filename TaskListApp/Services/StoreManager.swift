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
    func addTask(_ name: String, completion: (Tasker) -> Void) {
        let task = Tasker(context: context)
        task.name = name
        completion(task)
        saveContext()
    }
    
    func addSubtask(_ name: String, for task: Tasker, completion: (Subtasker) -> Void) {
        let subtask = Subtasker(context: context)
        subtask.name = name
//        subtask.task = task // FIXME: Почему можно не указывать? Потому что связь Инверсная?
        subtask.isImportant = Bool.random()
        task.addToSubtasks(subtask)
        completion(subtask)
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
    
    func fetchSubtaskData(for task: Tasker, completion: (Result<[Subtasker], Error>) -> Void) {
        let fetchRequest = Subtasker.fetchRequest()
        // Set up a predicate to filter subtasks related to the specific task
        // FIXME: можно ли как то по другому получать информацию по конкретной таске?
        let predicate = NSPredicate(format: "task == %@", task)
        fetchRequest.predicate = predicate

        do{
            let tasks = try context.fetch(fetchRequest)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    // Delete
    // Так норм? или оптимизировать как то можно? Пока придумал что подписать на протокол и кинуть протокол в delete(_ data: ProtocolName)
    func delete(_ data: Tasker) {
        context.delete(data)
        saveContext()
    }
        
    func delete(_ data: Subtasker) {
        context.delete(data)
        saveContext()
    }
    
    // Update
    func updateTask(_ task: Tasker, withName name: String, completion: () -> Void) {
        // Update the task properties
        task.name = name
        // Save the context to persist the changes
        saveContext()
        // Call the completion handler if needed
        completion()
    }

    // MARK: - Core Data Saving support

    func saveContext () {
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
