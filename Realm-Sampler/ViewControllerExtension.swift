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
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // スワイプでDeleteボタンを表示
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            tableView.editing = false
            // 該当のデータを定数に代入
            let item = self.realm.objects(ToDoModel)[indexPath.row]
            // 該当のデータをデータベースを削除する
            try! self.realm.write {
                self.realm.delete(item
                )
            }
            // UITableViewから削除する
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        // スワイプでDoneボタンを表示
        let done = UITableViewRowAction(style: .Normal, title: "DONE") { (action, indexPath) in
            // 該当のデータを定数に代入
            let item = self.realm.objects(ToDoModel)[indexPath.row]
            //データベースのデータを更新する
            try! self.realm.write({
                item.isDone = 1 // isDoneの値を1に変更
            })
        }
        
        done.backgroundColor = UIColor.greenColor()
        
        // スワイプでEditボタンを表示
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexpath) in
            // AddViewに渡すデータを代入
            self.todo = self.todos[indexPath.row]
            self.transition() // 画面遷移
        }
        
        return [delete, done, edit]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = todoTable.dequeueReusableCellWithIdentifier("todoCell") as! TodoCell
        
        let item = todos[indexPath.row]
        cell.duedateLabel.text = item.due_date.convertDate()
        cell.todoLabel.text = item.todo
        
        return cell
    }
}
