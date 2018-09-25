//
//  ToDoModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

public enum FetchType { // 取得するデータを決めるためのenum
    case all // すべてのToDoを取得するためのenum
    case undone // 完了していないToDoを取得するためのenum
}

class ToDoModel: Object {
    
    static let realm = try! Realm()
    
    @objc dynamic private var id: Int = 0 // データのID
    @objc dynamic var todo: String = "" //ToDoの内容
    @objc dynamic var category: CategoryModel? //ToDoのカテゴリー
    @objc dynamic var dueDate: Date! // ToDoの期限
    @objc dynamic var isDone: Int = 0 // ToDoが完了しているか。0なら未完了、1なら完了
    
    // idをプライマリーキーに設定
    override static func primaryKey() -> String {
        return "id"
    }

    // initでインスタンスを作成
    convenience init(content: String, category: CategoryModel, dueDate: Date) {
        self.init()
        self.todo = content
        self.category = category
        self.dueDate = dueDate
        self.isDone = 0
        self.id = ToDoModel.lastId()
    }

    
    // Todoの内容を変更し、更新するためのメソッド
    static func update(model: ToDoModel,content: String, category: CategoryModel, dueDate: Date) {
        // ローカルのdefault.realmとのtransactionを生成
        try! realm.write{
            // それぞれのカラムにデータを入れる
            model.todo = content
            model.category = category
            model.dueDate = dueDate
            model.isDone = 0
        }
    }
    
    // FetchTypeで呼び出すメソッドを変更
    static func fetch(FetchType type: FetchType) -> [ToDoModel] {
        // .Allなら全件、.UnDoneなら未完了のデータを取得する
        switch type {
        case .all:
            return loadAll()
        case .undone:
            return loadUndone()
        }
    }
    
    // すべてのデータを取得するメソッド
    static func loadAll() -> [ToDoModel] {
        // idでソートしながら、全件取得
        let todos = realm.objects(ToDoModel.self).sorted(byKeyPath: "id", ascending: true)
        // 取得したデータを配列にいれる
        var ret: [ToDoModel] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    
    // 完了していないToDoを取得するメソッド
    static func loadUndone() -> [ToDoModel] {
        // isDoneが0でフィルターをかけて取得
        let todos = realm.objects(ToDoModel.self).filter("isDone == 0")
        //取得したデータを配列にいれる
        var ret: [ToDoModel] = []
        for todo in todos {
            ret.append(todo)
        }
        return ret
    }
    
    static func lastId() -> Int {
        // isDoneの値を変更するとデータベース上の順序が変わるために、以下のようにしてidでソートして最大値を求めて+1して返す
        // 更新の必要がないなら、 realm.objects(ToDoModel).last で最後のデータのidを取得すればよい
        if let todo = realm.objects(ToDoModel.self).sorted(byKeyPath: "id", ascending: false).first {
            return todo.id + 1
        }else {
            return 1
        }
    }
    
    // ローカルのdefault.realmに作成したデータを保存するメソッド
    func save() {
        // writeでtransactionを生む
        let realm = try! Realm()
        try! realm.write {
            // モデルを保存
            realm.add(self)
        }
    }
    
    // TODO: UITableViewRowActionからインスタンスを送れない
    func delete(idOfDelete id: Int)  {
        let item = ToDoModel.realm.objects(ToDoModel.self)[id]
        try! ToDoModel.realm.write {
            ToDoModel.realm.delete(item)
        }
    }
    
    func updateDone(idOfUpdate id: Int) {
        let item = ToDoModel.realm.objects(ToDoModel.self)[id]
        try! ToDoModel.realm.write {
            item.isDone = 1
        }
    }
}
