//
//  ViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

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
        
        todoTable.estimatedRowHeight = 90
        todoTable.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read() {
        
    }
    
    @IBAction func didSelectAdd() {
        self.performSegueWithIdentifier("toAdd", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = todoTable.dequeueReusableCellWithIdentifier("todoCell") as! TodoCell
        
        return cell
    }
}

