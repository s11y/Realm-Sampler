//
//  ViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet var todoTable: UITableView!
    
    var todos = [ToDoModel]()
    
    var todo: ToDoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        todoTable.delegate = self
        todoTable.dataSource = self
        
        todoTable.registerNib(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "todoCell")
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.read()
        
        todoTable.estimatedRowHeight = 90
        todoTable.rowHeight = UITableViewAutomaticDimension
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read() {
        todos = ToDoModel.loadAll()
        todoTable.reloadData()
    }
    
    func didSelectDONE() {
        self.performSegueWithIdentifier("toAdd", sender: self)
    }
    
    @IBAction func didSelectAdd() {
        self.performSegueWithIdentifier("toAdd", sender: self)
    }
    
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
        
        let done = UITableViewRowAction(style: .Normal, title: "DONE") { (action, indexPath) in
//            ToDoModel().updateDone(idOfUpdate: indexPath.row)
            let item = self.realm.objects(ToDoModel)[indexPath.row]
            try! self.realm.write({ 
                item.isDone = 1
            })
        }
        
        return [delete, done]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = todoTable.dequeueReusableCellWithIdentifier("todoCell") as! TodoCell
        
        let item = todos[indexPath.row]
        cell.duedateLabel.text = self.getDate(due_date: item.due_date)
        cell.todoLabel.text = item.todo
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAdd" {
            guard let updatingTodo = self.todo else { return }
            let addView = segue.destinationViewController as! AddViewController
            addView.updatingTodo = updatingTodo
        }
    }
    
    func getDate(due_date date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.stringFromDate(date)
    }
}

