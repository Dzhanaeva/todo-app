//
//  ToDoEntity.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import Foundation

struct ToDoItem: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    let userId: Int
    var category: String?
    var dateComplete: Date?
}

struct ToDoListResponse: Codable {
    var todos: [ToDoItem]
    var total: Int
    var skip: Int
    var limit: Int
}

