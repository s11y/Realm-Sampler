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
    
    @objc dynamic private var id: Int = 0 // CategoryModelのid
    @objc dynamic var category: String = "" // Categoryの内容

    
    let todoModel = List<ToDoModel>()
    
    // idをプライマリーキーに設定
    override static func primaryKey() -> String {
        return "id"
    }

    // initでインスタンスを作成
    convenience init(newCategory text: String) {
        self.init()
        self.id = CategoryModel.lastId()
        self.category = text
    }

    // データを更新するためのメソッド
    static func update(model: CategoryModel, content: String) {
        // ローカルのdefault.realmとのtransactionを生成
        try! realm.write {
            // categoryに内容を挿入
            model.category = content
        }
    }
    
    // idを取得するためのメソッド
    static func lastId() -> Int {
        // idの最大値を取得してから、+1して返す
        if let category = realm.objects(CategoryModel.self).sorted(byKeyPath: "id", ascending: false).first {
            return category.id + 1
        }else {
            return 1
        }
    }
    
    // 作成したデータを保存するためのメソッド
    func save() {
        // ローカルのdefault.realmとのtransactionを生成
        let realm = try! Realm()
        try! realm.write{
            // データを追加
            realm.add(self)
        }
    }
    
    // データを全件取得
    static func loadAll() -> [CategoryModel] {
        // idでソートして全件取得
        let categories = realm.objects(CategoryModel.self).sorted(byKeyPath: "id", ascending: true)
        // 取得したデータを配列に入れる
        var array: [CategoryModel] = []
        for category in categories {
            array.append(category)
        }
        return array
    }
}
