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
    
    dynamic private var id: Int = 0 // CategoryModelのid
    dynamic var category: String = "" // Categoryの内容
    
    let todoModel = List<ToDoModel>()
    
    // idをプライマリーキーに設定
    override static func primaryKey() -> String {
        return "id"
    }
    
    // 新しいCategoryのデータを作成するためのメソッド
    static func create(newCategory text: String) -> CategoryModel {
        // インスタンスを生成
        let category = CategoryModel()
        // それぞれにデータをいれる
        category.id = lastId()
        category.category = text
        
        return category
    }
    
    // データを更新するためのメソッド
    static func update(model: CategoryModel, content: String) {
        // ローカルのdefault.realmとのtransactionを生成
        try! realm.write {
            // 
            model.category = content
        }
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
