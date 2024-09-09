//
//  AddNewTaskRouter.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 09.09.2024.
//


import UIKit

protocol AddNewTaskRouterProtocol: AnyObject {
    func dismiss()
}

class AddNewTaskRouter: AddNewTaskRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(with task: Tasks?) -> UIViewController {
        let view = AddNewTaskViewController()
        let interactor = AddNewTaskInteractor()
        let presenter = AddNewTaskPresenter()
        let router = AddNewTaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        interactor.task = task
        
        return view
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
