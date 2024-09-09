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
    
    private let tabStackView = UIStackView()
    private let stackViewOne = UIStackView()
    private let stackViewTwo = UIStackView()
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
    
    enum TaskFilter {
        case all
        case open
        case closed
    }
    
    
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
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    

    
    private func setupView() {
        setupStackViews()
        setupConstraints()
        setupActions()
        updateButtonSelection()
    }

    private func setupStackViews() {
        tabStackView.axis = .horizontal
        tabStackView.distribution = .equalSpacing
        tabStackView.alignment = .center
        tabStackView.spacing = 10
        tabStackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewOne.axis = .horizontal
        stackViewOne.distribution = .equalSpacing
        stackViewOne.spacing = 40
        stackViewOne.alignment = .center
        stackViewOne.addArrangedSubview(allButton)
        stackViewOne.addArrangedSubview(separator)
        
        stackViewTwo.axis = .horizontal
        stackViewTwo.distribution = .equalSpacing
        stackViewTwo.spacing = 40
        stackViewTwo.alignment = .center
        stackViewTwo.addArrangedSubview(openButton)
        stackViewTwo.addArrangedSubview(closedButton)
        
        tabStackView.addArrangedSubview(stackViewOne)
        tabStackView.addArrangedSubview(stackViewTwo)
        
        addSubview(tabStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabStackView.topAnchor.constraint(equalTo: topAnchor),
            tabStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupActions() {
        allButton.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(closedButtonTapped), for: .touchUpInside)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FilterButton: UIButton {
    
    private let badgeLabel = UILabel()
    
    var badgeCount: Int = 0 {
        didSet {
            badgeLabel.text = "\(badgeCount)"

        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
        setupBadgeLabel()
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.lightGray, for: .normal)
        setTitleColor(.customBlue, for: .selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupBadgeLabel() {
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
    

    override var isSelected: Bool {
        didSet {
            badgeLabel.backgroundColor = isSelected ? .customBlue : .tintGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
