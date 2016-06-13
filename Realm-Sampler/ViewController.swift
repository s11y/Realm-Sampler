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
    
    @IBOutlet var segment: UISegmentedControl!
    
    var todos: [ToDoModel] = []
    
    var todo: ToDoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        todoTable.delegate = self
        todoTable.dataSource = self
        
        todoTable.registerNib(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
        segment.addTarget(self, action: #selector(self.changeSegment(_:)), forControlEvents: .TouchUpInside)
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
        todos = ToDoModel.loadUndone()
        segment.selectedSegmentIndex = 0
        todoTable.reloadData()
    }
    
    func changeSegment(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            todos = ToDoModel.fetch(FetchType: .UnDone)
        case 1:
            todos = ToDoModel.fetch(FetchType: .All)
        default:
            break
        }
        todoTable.reloadData()
    }
    
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAdd" {
            guard let updatingTodo = self.todo else { return }
            let addView = segue.destinationViewController as! AddViewController
            addView.updatingTodo = updatingTodo
        }
    }
    
    func transition() {
        self.performSegueWithIdentifier("toAdd", sender: self)
    }
}

