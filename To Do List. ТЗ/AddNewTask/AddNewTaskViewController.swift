//
//  AddNewTaskViewController.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 04.09.2024.
//

import UIKit

protocol AddNewTaskViewControllerProtocol: AnyObject {
    func showTask()
}

class AddNewTaskViewController: UIViewController, AddNewTaskViewControllerProtocol  {
    
    var presenter: AddNewTaskPresenterProtocol!
    var interactor: AddNewTaskInteractorProtocol!
    var router: AddNewTaskRouterProtocol!
    
    private let manager = CoreManager.shared
    var task: Tasks?
    private var isDateSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Task"
        
        let router = AddNewTaskRouter()
        let presenter = AddNewTaskPresenter()
        let interactor = AddNewTaskInteractor()
        
        self.router = router
        self.presenter = presenter
        self.interactor = interactor
        
        presenter.router = router
        presenter.view = self
        presenter.interactor = interactor
        router.viewController = self
        interactor.task = task
        presenter.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: UITextView.textDidChangeNotification, object: nil)
        view.addSubviews(tasksContainerView, categoryContainerView, viewDate, saveBtn)
        setupConstraints()
        showTask()
        
        
        dateWhenComplete.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
    }
    
    @objc func dateChanged() {
        isDateSelected = true
    }
    
    lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Category"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tasksTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var tasksPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tasksContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tasksTextView)
        view.addSubview(tasksPlaceholderLabel)
        return view
    }()
    
    lazy var categoryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTextField)
        return view
    }()
    
    @objc func textViewDidChange(notification: NSNotification) {
        if let textView = notification.object as? UITextView {
            tasksPlaceholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    
    lazy var viewDate: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.addSubview(dateWhenComplete)
        return $0
    }(UIView())
    
    lazy var dateWhenComplete: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    
    lazy var saveBtn: UIButton = {
        $0.setTitle("Save", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .tintBlue
        $0.setTitleColor(.customBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.layer.cornerRadius = 13
        $0.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    
    @objc func saveTask() {
        let selectedDate: Date? = isDateSelected ? dateWhenComplete.date : nil
        presenter.saveTask(todo: tasksTextView.text, category: categoryTextField.text, date: selectedDate)
    }
    
    func showTask() {
        if let task = task {
            tasksTextView.text = task.todo
            categoryTextField.text = task.category
            if let date = task.date {
                dateWhenComplete.date = date
                isDateSelected = true
            }
            tasksPlaceholderLabel.isHidden = !tasksTextView.text.isEmpty
        }
    }

        
        func setupConstraints() {
            NSLayoutConstraint.activate([
                
                tasksContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                tasksContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                tasksContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tasksContainerView.heightAnchor.constraint(equalToConstant: 150),
                
                tasksTextView.leadingAnchor.constraint(equalTo: tasksContainerView.leadingAnchor, constant: 16),
                tasksTextView.trailingAnchor.constraint(equalTo: tasksContainerView.trailingAnchor, constant: -16),
                tasksTextView.topAnchor.constraint(equalTo: tasksContainerView.topAnchor, constant: 8),
                tasksTextView.bottomAnchor.constraint(equalTo: tasksContainerView.bottomAnchor, constant: -16),
                
                tasksPlaceholderLabel.leadingAnchor.constraint(equalTo: tasksTextView.leadingAnchor),
                tasksPlaceholderLabel.topAnchor.constraint(equalTo: tasksTextView.topAnchor, constant: 8),
                
                categoryContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categoryContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                categoryContainerView.topAnchor.constraint(equalTo: tasksContainerView.bottomAnchor, constant: 5),
                categoryContainerView.heightAnchor.constraint(equalToConstant: 56),
                
                categoryTextField.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
                categoryTextField.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -16),
                categoryTextField.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 10),
                categoryTextField.heightAnchor.constraint(equalToConstant: 40),
                
                viewDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                viewDate.topAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: 5),
                
                dateWhenComplete.leadingAnchor.constraint(equalTo: viewDate.leadingAnchor),
                dateWhenComplete.trailingAnchor.constraint(equalTo: viewDate.trailingAnchor),
                dateWhenComplete.topAnchor.constraint(equalTo: viewDate.topAnchor),
                dateWhenComplete.bottomAnchor.constraint(equalTo: viewDate.bottomAnchor),
                
                saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                saveBtn.topAnchor.constraint(equalTo: viewDate.bottomAnchor, constant: 30),
                saveBtn.heightAnchor.constraint(equalToConstant: 50),
                saveBtn.widthAnchor.constraint(equalToConstant: 150),
            ])
            
        }
        
    }
