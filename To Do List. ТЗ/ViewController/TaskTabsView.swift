//
//  TaskTabsVIew.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 09.09.2024.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterView(_ filterView: FilterView, didSelectFilter filter: FilterView.TaskFilter)
}

class FilterView: UIView {
    
    weak var delegate: FilterViewDelegate?
    
    private let stackView = UIStackView()
    private let allButton = FilterButton(title: "All")
    private let openButton = FilterButton(title: "Open")
    private let closedButton = FilterButton(title: "Closed")
    
    private var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .tintGray
        view.layer.cornerRadius = 2
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var allCount: Int = 0 {
        didSet {
            allButton.badgeCount = allCount
        }
    }
    
    var openCount: Int = 0 {
        didSet {
            openButton.badgeCount = openCount
        }
    }
    
    var closedCount: Int = 0 {
        didSet {
            closedButton.badgeCount = closedCount
        }
    }
    
    var selectedFilter: TaskFilter = .all {
        didSet {
            updateButtonSelection()
            delegate?.filterView(self, didSelectFilter: selectedFilter)
        }
    }
    
    enum TaskFilter {
        case all
        case open
        case closed
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(allButton)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(openButton)
        stackView.addArrangedSubview(closedButton)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: openButton.leadingAnchor, constant: 1),
        ])
        
        allButton.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(closedButtonTapped), for: .touchUpInside)
        
        updateButtonSelection()
    }
    
    @objc private func allButtonTapped() {
        selectedFilter = .all
    }
    
    @objc private func openButtonTapped() {
        selectedFilter = .open
    }
    
    @objc private func closedButtonTapped() {
        selectedFilter = .closed
    }
    
    private func updateButtonSelection() {
        allButton.isSelected = (selectedFilter == .all)
        openButton.isSelected = (selectedFilter == .open)
        closedButton.isSelected = (selectedFilter == .closed)
    }
}

class FilterButton: UIButton {
    
    private let badgeLabel = UILabel()
    
    var badgeCount: Int = 0 {
        didSet {
            badgeLabel.text = "\(badgeCount)"
            badgeLabel.isHidden = (badgeCount == 0)
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.lightGray, for: .normal)
        setTitleColor(.customBlue, for: .selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
        
        badgeLabel.font = UIFont.systemFont(ofSize: 14)
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.layer.masksToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            badgeLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            badgeLabel.widthAnchor.constraint(equalToConstant: 25),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            badgeLabel.backgroundColor = isSelected ? .customBlue : .tintGray
        }
    }
}
