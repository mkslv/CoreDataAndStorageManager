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
    // Create task
    func addTask(_ name: String, completion: (Tasker) -> Void) {
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
    
    func fetchSubtaskData(for task: Tasker, completion: (Result<[Subtasker], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Subtasker> = Subtasker.fetchRequest()

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
    func delete(_ data: Tasker) {
        // Delete all child tasks - subtasks
        if let subtasks = data.subtasks {
            for case let subtask as Subtasker in subtasks {
                context.delete(subtask)
            }
        }
        // Delete main task
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
    
    // MARK: - Subtask CRUD Methods
    // Create subtask
    func addSubtask(_ name: String, for task: Tasker, completion: (Subtasker) -> Void) {
        let subtask = Subtasker(context: context)
        subtask.name = name
        subtask.isImportant = Bool.random()
        subtask.task = task
        
        task.addToSubtasks(subtask)
        saveContext()
        completion(subtask)
    }
    
    // Retrieve subtasks for a specific task // FIXME: должно ли это вообщ быть в СторМенеджере?
    func fetchSubtasks(for task: Tasker, completion: (Result<[Subtasker], Error>) -> Void) {
        if let subtasks = task.subtasks?.array as? [Subtasker] {
            completion(.success(subtasks))
        } else {
            completion(.success([]))
        }
    }
    
    // Delete subtask
    func delete(_ data: Subtasker) {
        context.delete(data)
        saveContext()
    }
    
    // Update subtask
    func updateSubtask(_ subtask: Subtasker, newName: String, newImportance: Bool) {
        subtask.name = newName
        subtask.isImportant = newImportance
        saveContext()
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
