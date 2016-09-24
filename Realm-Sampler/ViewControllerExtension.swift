//
//  ViewControllerExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // スワイプでDeleteボタンを表示
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            tableView.isEditing = false
            // 該当のデータを定数に代入
            let item = self.realm.allObjects(ofType: ToDoModel.self)[indexPath.row]
            // 該当のデータをデータベースを削除する
            try! self.realm.write {
                self.realm.delete(item
                )
            }
            // UITableViewから削除する
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = UIColor.red
        
        // スワイプでDoneボタンを表示
        let done = UITableViewRowAction(style: .normal, title: "DONE") { (action, indexPath) in
            // 該当のデータを定数に代入
            let item = self.realm.allObjects(ofType: ToDoModel.self)[indexPath.row]
            //データベースのデータを更新する
            try! self.realm.write(block: {
                item.isDone = 1 // isDoneの値を1に変更
            })
        }
        
        done.backgroundColor = UIColor.green
        
        // スワイプでEditボタンを表示
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            // AddViewに渡すデータを代入
            self.todo = self.todos[indexPath.row]
            self.transition() // 画面遷移
        }
        
        return [delete, done, edit]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTable.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        
        let item = todos[indexPath.row]
        cell.duedateLabel.text = item.due_date.convertDate()
        cell.todoLabel.text = item.todo
        
        return cell
    }
}
