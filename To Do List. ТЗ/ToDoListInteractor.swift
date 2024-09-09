//
//  ToDoListInteractor.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit

protocol ToDoListInteractorProtocol: AnyObject {
    func loadData()
}


class ToDoListInteractor: ToDoListInteractorProtocol {
    
    func loadData() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let response = try JSONDecoder().decode(ToDoListResponse.self, from: data)
                DispatchQueue.main.async {
                    CoreManager.shared.saveTasksFromDatabase(response.todos)
                }
            } catch {
                print("Decoding error: \(error)")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Received JSON: \(json)")
                }
            }
        }
        task.resume()
    }
}

