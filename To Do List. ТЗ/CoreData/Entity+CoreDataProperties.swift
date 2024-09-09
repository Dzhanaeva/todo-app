//
//  Entity+CoreDataProperties.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 05.09.2024.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var id: Int32
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int32
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var creationDate: Date?

}

extension Tasks : Identifiable {
    func updateTask(newToDo: String, newCategory: String?, newDate: Date?) {
        self.todo = newToDo
        self.category = newCategory
        self.date = newDate
        
        try? managedObjectContext?.save()
    }
    
    func deleteTask() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
}
