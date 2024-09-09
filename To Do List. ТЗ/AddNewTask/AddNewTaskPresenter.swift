//
//  AddNewTaskPresenter.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 09.09.2024.
//

import Foundation

protocol AddNewTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(todo: String, category: String?, date: Date?)
    func didFetchTask(_ task: Tasks)
    var view: AddNewTaskViewControllerProtocol? { get set}
}

class AddNewTaskPresenter: AddNewTaskPresenterProtocol {
    
    weak var view: AddNewTaskViewControllerProtocol?
    var interactor: AddNewTaskInteractorProtocol?
    var router: AddNewTaskRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchTask()
    }
    
    func saveTask(todo: String, category: String?, date: Date?) {
        interactor?.saveTask(todo: todo, category: category, date: date)
        router?.dismiss()
    }
    
    func didFetchTask(_ task: Tasks) {
        view?.showTask()
    }
}
