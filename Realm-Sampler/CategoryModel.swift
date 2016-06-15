//
//  CategoryModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CategoryModel: Object {
    
    static let realm = try! Realm()
    
    dynamic private var id: Int = 0
    dynamic var category: String = ""
    
    let todoModel = List<ToDoModel>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func create() -> CategoryModel {
        let category = CategoryModel()
        category.id = lastId()
        return category
    }
    
    static func lastId() -> Int {
        if let category = realm.objects(CategoryModel).sorted("id", ascending: false).first {
            return category.id + 1
        }else {
            return 1
        }
    }
    func save() {
        try! CategoryModel.realm.write{
            CategoryModel.realm.add(self)
        }
    }
    
    static func loadAll() -> [CategoryModel] {
        let categories = realm.objects(CategoryModel).sorted("id", ascending: true)
        var array: [CategoryModel] = []
        for category in categories {
            array.append(category)
        }
        return array
    }
}
