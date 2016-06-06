//
//  ToDoModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoModel: Object {
    
    static let realm = try! Realm()
    
    dynamic private var id: Int = 0
    dynamic var todo: String = ""
    dynamic var category: Int = 0
    dynamic var due_date: NSDate!
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func create() -> ToDoModel {
        let todo = ToDoModel()
        return todo
    }
    
    static func loadAll() -> [ToDoModel] {
        let todos = realm.objects(ToDoModel).sorted("id", ascending: false)
        var ret: [ToDoModel] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let todo = realm.objects(ToDoModel).last {
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
}
