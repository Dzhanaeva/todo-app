//
//  AddNewTaskInterator.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 09.09.2024.
//

import Foundation

protocol AddNewTaskInteractorProtocol: AnyObject {
    func saveTask(todo: String, category: String?, date: Date?)
    func fetchTask()
}

class AddNewTaskInteractor: AddNewTaskInteractorProtocol {
    
    weak var presenter: AddNewTaskPresenterProtocol?
    private let manager = CoreManager.shared
    
    var task: Tasks?
    
    func saveTask(todo: String, category: String?, date: Date?) {
        if task == nil {
            manager.addNewTask(todo: todo, category: category, date: date)
        } else {
            task?.updateTask(newToDo: todo, newCategory: category, newDate: date)
            NotificationCenter.default.post(name: .didAddNewTask, object: nil)
        }
        
    }
    
    func fetchTask() {
        if let task = task {
            presenter?.didFetchTask(task)
        }
    }
    
}
