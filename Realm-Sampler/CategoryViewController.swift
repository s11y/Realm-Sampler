//
//  CategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var categoryTable: UITableView!
    
    var categories: [CategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.read()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    func read() {
        categories = CategoryModel.loadAll()
        categoryTable.reloadData()
    }
    
    func transition() {
        self.performSegueWithIdentifier("toAddCategory", sender: self)
    }
}
