//
//  CoreManager.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 05.09.2024.
//

import Foundation
import CoreData

class CoreManager {
    static let shared = CoreManager()
    var tasks = [Tasks]()
    private init() {
        fetchAllTasks()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "To_Do_List____")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
    
    func fetchAllTasks() {
        let req = Tasks.fetchRequest()
        if let tasks = try? persistentContainer.viewContext.fetch(req) {
            self.tasks = tasks
        }
    }
    
    func addNewTask(todo: String, category: String?, date: Date?) {
        let task = Tasks(context: persistentContainer.viewContext)
        task.id = Int32(Date().timeIntervalSince1970)
        task.todo = todo
        task.category = category
        task.completed = false
        task.date = date
        task.creationDate = Date()
        
        saveContext()
        fetchAllTasks()
        print("new", task)
    }
    
    
    func saveTasksFromDatabase( _ items: [ToDoItem]) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        do {
            let existingTasks = try context.fetch(fetchRequest)
            
            var existingTasksDict = [Int32: Tasks]()
            for task in existingTasks {
                existingTasksDict[task.id] = task
            }
            
            for item in items {
                if let existingTask = existingTasksDict[Int32(item.id)] {

                    existingTask.todo = item.todo
                    existingTask.category = item.category
                    existingTask.date = item.dateComplete
                    existingTask.userId = Int32(item.userId)
                } else {
    
                    let newTask = Tasks(context: context)
                    newTask.id = Int32(item.id)
                    newTask.todo = item.todo
                    newTask.category = item.category
                    newTask.date = item.dateComplete
                    newTask.completed = item.completed
                    newTask.userId = Int32(item.userId)
                }
            }
            
            try context.save()
        } catch {
            print("error \(error)")
        }
    }
    

}

