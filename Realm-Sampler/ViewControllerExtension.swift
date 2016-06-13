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
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            tableView.editing = false
            //            ToDoModel().delete(idOfDelete :indexPath.row)
            let item = self.realm.objects(ToDoModel)[indexPath.row]
            try! self.realm.write {
                self.realm.delete(item
                )
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        let done = UITableViewRowAction(style: .Normal, title: "DONE") { (action, indexPath) in
            //            ToDoModel().updateDone(idOfUpdate: indexPath.row)
            let item = self.realm.objects(ToDoModel)[indexPath.row]
            try! self.realm.write({
                item.isDone = 1
            })
        }
        
        done.backgroundColor = UIColor.greenColor()
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexpath) in
            self.todo = self.todos[indexPath.row]
            self.transition()
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
