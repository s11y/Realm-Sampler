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
    
    @IBOutlet var todoTable: UITableView!
    
    var todos = [ToDoModel]()
    
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
        
        print(todos)
        todoTable.reloadData()
    }
    
    @IBAction func didSelectAdd() {
        self.performSegueWithIdentifier("toAdd", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            delete(indexPath.row)
            
        }
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
    
    func getDate(due_date date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.stringFromDate(date)
    }
    
    private func delete(id: Int) {
        let realm = try! Realm()
        let item = realm.objects(ToDoModel)[id]
        try! realm.write {
            realm.delete(item)
        }
    }
}

