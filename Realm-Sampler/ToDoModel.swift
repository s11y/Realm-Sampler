//
//  ToDoModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

public enum FetchType {
    case All
    case UnDone
}

class ToDoModel: Object {
    
    static let realm = try! Realm()
    
    dynamic private var id: Int = 0
    dynamic var todo: String = ""
    dynamic var category: Int = 0
    dynamic var due_date: NSDate!
    dynamic var isDone: Int = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func create(content: String, category: Int, dueDate: NSDate) -> ToDoModel {
        let todo = ToDoModel()
        todo.todo = content
        todo.category = category
        todo.due_date = dueDate
        todo.isDone = 0
        todo.id = lastId()
        return todo
    }
    
    static func update(content: String, category: Int, dueDate: NSDate) -> ToDoModel {
        let todo = ToDoModel()
        todo.todo = content
        todo.category = category
        todo.due_date = dueDate
        return todo
    }
    
    static func fetch(FetchType type: FetchType) -> [ToDoModel] {
        switch type {
        case .All:
            return loadAll()
        case .UnDone:
            return loadUndone()
        }
    }
    
    static func loadAll() -> [ToDoModel] {
        let todos = realm.objects(ToDoModel).sorted("id", ascending: true)
        var ret: [ToDoModel] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    
    static func loadUndone() -> [ToDoModel] {
        let todos = realm.objects(ToDoModel).filter("isDone = 0")
        var ret: [ToDoModel] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    
    static func lastId() -> Int {
        // isDoneの値を変更するとデータベース上の順序が変わるために、変更
        // 具体的には、一番上にくるため
//        if let todo = realm.objects(ToDoModel).last {
        if let todo = realm.objects(ToDoModel).sorted("id", ascending: false).first {
            return todo.id + 1
        }else {
            return 1
        }
    }
    
    func save() {
        try! ToDoModel.realm.write {
            ToDoModel.realm.add(self)
        }
    }
    
    // MARK: UITableViewRowActionからインスタンスを送れない
    func delete(idOfDelete id: Int)  {
        let item = realm?.objects(ToDoModel)[id]
        try! realm?.write {
            realm?.delete(item!)
        }
    }
    
    func updateDone(idOfUpdate id: Int) {
        let item = realm?.objects(ToDoModel)[id]
        try! realm?.write {
            item?.isDone = 1
        }
    }
}
