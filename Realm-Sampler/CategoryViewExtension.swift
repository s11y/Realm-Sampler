//
//  CategoryViewExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

extension CategoryViewController {
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        
        cell.categoryLabel.text = categories[indexPath.row].category
        
        return cell
    }
    
    // categoryTableのスワイプ処理
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Swipeの時の、Deleteボタン
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, index) in
            self.categories.removeAtIndex(indexPath.row) // 配列から削除
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) // TableViewから削除
            self.deleteModel(index: indexPath.row) // 該当のデータをデータベースから削除
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        // Swipeの時の、Editボタン
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, index) in
            self.updatingCategory = self.categories[index.row] // データを保存するための変数に代入
            self.transition() // 画面遷移
        }
        
        return [delete, edit]
    }
}
