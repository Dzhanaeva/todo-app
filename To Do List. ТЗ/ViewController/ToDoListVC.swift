//
//  ToDoListVC.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit
import CoreData

protocol ToDoListVCProtocol: AnyObject {
    func reloadData()
}

class ToDoListVC: UIViewController, ToDoListVCProtocol, FilterViewDelegate {
    
    var presenter: ToDoListPresenterProtocol!
    var router: TodoListRouterProtocol!
    var interactor: ToDoListInteractorProtocol!
    
    private var currentFilter: FilterView.TaskFilter = .all {
        didSet {
            setupFetchedResultsController()
        }
    }
    private let filterView = FilterView()
    
    private var fetchedResultsController: NSFetchedResultsController<Tasks>!
    
    enum TaskFilter {
        case all
        case open
        case closed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter()
        let interactor = ToDoListInteractor()
        
        self.router = router
        self.presenter = presenter
        self.interactor = interactor
        
        presenter.router = router
        presenter.view = self
        presenter.interactor = interactor
        router.viewController = self
        presenter.viewDidLoad()
        
        view.addSubviews(headLabel, dateLabel, addTaskBtn, filterView, taskCollectionView)
        setupContraints()
        setupFetchedResultsController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNewTask), name: .didAddNewTask, object: nil)
        
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false

        
    }
    
    func filterView(_ filterView: FilterView, didSelectFilter filter: FilterView.TaskFilter) {
        currentFilter = filter
        
    }

    
    //MARK: - UI
    
    lazy var headLabel: UILabel = {
        $0.text = "Today's Task"
        $0.font = .systemFont(ofSize: 27, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter
    }()
    
    lazy var dateLabel: UILabel = {
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        $0.text = dateString
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var addTaskBtn: UIButton = {
        let plusString = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        let textString = NSAttributedString(string: " New Task", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        let combinedString = NSMutableAttributedString()
        combinedString.append(plusString)
        combinedString.append(textString)
        $0.setAttributedTitle(combinedString, for: .normal)
        $0.backgroundColor = .tintBlue
        $0.tintColor = .systemBlue
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    
    lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ToDoItemCell.self, forCellWithReuseIdentifier: ToDoItemCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
        



    
    
    //MARK: - Данные
    
    @objc func addNewTask() {
        presenter.didTapNewTaskBtn()
    }
    
    @objc private func didAddNewTask() {
        setupFetchedResultsController()
    }
    
    private func getTasksCount(predicate: NSPredicate?) -> Int {
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let count = try CoreManager.shared.persistentContainer.viewContext.count(for: fetchRequest)
            return count
        } catch {
            return 0
        }
    }


    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        switch currentFilter {
        case .all:
            fetchRequest.predicate = nil
        case .open:
            fetchRequest.predicate = NSPredicate(format: "completed == NO")
        case .closed:
            fetchRequest.predicate = NSPredicate(format: "completed == YES")
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        DispatchQueue.global(qos: .background).async {
            do {
                try self.fetchedResultsController.performFetch()
                DispatchQueue.main.async {
                    self.reloadData()
                }
            } catch {
                print("Failed to fetch tasks: \(error)")
            }
        }
    }
    
    @objc private func showAllTasks() {
        currentFilter = .all
        setupFetchedResultsController()
    }
    
    @objc private func showOpenTasks() {
        currentFilter = .open
        setupFetchedResultsController()
    }
    
    @objc private func showClosedTasks() {
        currentFilter = .closed
        setupFetchedResultsController()
    }
    
    func reloadData() {
        taskCollectionView.reloadData()
        filterView.allCount = getTasksCount(predicate: nil)
        filterView.openCount = getTasksCount(predicate: NSPredicate(format: "completed == NO"))
        filterView.closedCount = getTasksCount(predicate: NSPredicate(format: "completed == YES"))
    }
    
    
    // MARK: - Констрейнты
    private func setupContraints() {
        NSLayoutConstraint.activate([
            headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 2),
            
            addTaskBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTaskBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addTaskBtn.heightAnchor.constraint(equalToConstant: 40),
            addTaskBtn.widthAnchor.constraint(equalToConstant: 125),
            
            filterView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
              filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              filterView.heightAnchor.constraint(equalToConstant: 40),

            taskCollectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 20),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            
        ])
    }
}
    

// MARK: - Extension


extension ToDoListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(items.count, "в items")
//        print(fetchedResultsController.fetchedObjects?.count, "core data")
        return fetchedResultsController.fetchedObjects?.count ?? 0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoItemCell.reuseId, for: indexPath) as! ToDoItemCell
        let task = fetchedResultsController.object(at: indexPath)
        cell.configure(with: task)
        
        print(task, "задачи")
        return cell
        }
        
    }


extension ToDoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = collectionView.frame.width - 32
        let task = fetchedResultsController.object(at: indexPath)
           let autoCell = ToDoItemCell(frame: CGRect(x: 0, y: 0, width: width, height: 100))
        autoCell.configure(with: task)
           autoCell.layoutIfNeeded()
           let size = autoCell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
           return CGSize(width: width, height: size.height)
       }
    
}

extension ToDoListVC: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let task = fetchedResultsController.object(at: indexPath)
            router.navigateToEditTask(task: task)
        }
}


extension ToDoListVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadData()
    }
}

extension Notification.Name {
    static let didAddNewTask = Notification.Name("didAddNewTask")
}





