//
//  ToDoListPresenter.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit

protocol ToDoListPresenterProtocol: AnyObject {
    func didTapNewTaskBtn()
    func didTapCheckButton(for task: Tasks)
    func viewDidLoad()
    var view: ToDoListVCProtocol? { get set}
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    
    var router: TodoListRouterProtocol!
    var interactor: ToDoListInteractor!
    weak var view: ToDoListVCProtocol?
    
    func didTapNewTaskBtn() {
        router.navigateToAddTask()
    }
    
    func didTapCheckButton(for task: Tasks) {
        task.completed.toggle()
        CoreManager.shared.saveContext()
        router.updateCheckButton(for: task)
        view?.reloadData()
    }
    
    func viewDidLoad() {
        interactor.loadData()
    }
    
    
}
