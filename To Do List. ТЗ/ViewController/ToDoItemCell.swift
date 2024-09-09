//
//  ToDoItemCell.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit

protocol ToDoItemCellProtocol: AnyObject {
    
}

class ToDoItemCell: UICollectionViewCell, ToDoItemCellProtocol {
        
    var presenter: ToDoListPresenterProtocol!
    var router: TodoListRouterProtocol!
    var task: Tasks!
    
    static let reuseId = "ToDoItemCell"
    
        lazy var toDoLabel: UILabel = {
            $0.font = .systemFont(ofSize: 20, weight: .regular)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
             return $0
        }(UILabel())
    
        lazy var categoryLabel: UILabel = {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .lightGray
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
             return $0
        }(UILabel())
    
        lazy var checkmark: UIButton = {
            $0.heightAnchor.constraint(equalToConstant: 27).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 27).isActive = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
            return $0
        }(UIButton(type: .system))
    
    lazy var separator: UIView = {
        $0.backgroundColor = .tintGray
        $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var dateWhenCompleteLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    @objc func didTapCheckButton() {
        presenter.didTapCheckButton(for: task)
    }
    
    
    func configure(with task: Tasks) {
        self.task = task
        toDoLabel.attributedText = attributedText(for: task.todo ?? "", isCompleted: task.completed)
        categoryLabel.text = task.category
        
        if let dateComplete = task.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.dateFormat = "h:mm a"
            dateWhenCompleteLabel.text = "Today \(formatter.string(from: dateComplete))"
            
        } else {
            dateWhenCompleteLabel.text = ""
        }
        router.updateCheckButton(for: task)
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(toDoLabel, categoryLabel, checkmark, dateWhenCompleteLabel, separator)
        
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter()
        
        self.router = router
        self.presenter = presenter
    
        presenter.router = router
        router.button = checkmark
        setupViews()
        setupConstrints()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attributedText(for text: String, isCompleted: Bool) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        isCompleted ? [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ] : [
            .foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func setupViews() {
        contentView.layer.cornerRadius = 20
          contentView.layer.shadowColor = UIColor.black.cgColor
          contentView.layer.shadowOpacity = 0.1
          contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
          contentView.layer.shadowRadius = 4
          contentView.backgroundColor = .white
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale


    }
    
    func setupConstrints() {
        NSLayoutConstraint.activate([
            
            
            checkmark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            toDoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            toDoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            toDoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),

            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.topAnchor.constraint(equalTo: toDoLabel.bottomAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            
            dateWhenCompleteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateWhenCompleteLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            dateWhenCompleteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        
        ])

    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}

extension ToDoItemCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _  in
            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { action in
                self.task.deleteTask()
                self.presenter.view?.reloadData()
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}

