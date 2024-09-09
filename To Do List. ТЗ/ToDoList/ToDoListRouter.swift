//
//  ToDoListRouter.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit
import CoreData

protocol TodoListRouterProtocol: AnyObject {
    func navigateToAddTask()
    func updateCheckButton(for task: Tasks) 
    func navigateToEditTask(task: Tasks)
}

class ToDoListRouter: TodoListRouterProtocol {
    
    weak var viewController: UIViewController?
    var button: UIButton!
    
    func navigateToAddTask() {
        let editTaskVc = AddNewTaskViewController()
        let navigationController = UINavigationController(rootViewController: editTaskVc)
        
        viewController?.navigationController?.present(navigationController, animated: true)
    }
    
    func updateCheckButton(for task: Tasks) {
         if task.completed {
             button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
         } else {
             button.setImage(UIImage(systemName: "circle"), for: .normal)
         }
     }
    
    func navigateToEditTask(task: Tasks) {
        let editTaskVc = AddNewTaskViewController()
        editTaskVc.task = task
        let navigationController = UINavigationController(rootViewController: editTaskVc)
        viewController?.navigationController?.present(navigationController, animated: true)
    }
}
