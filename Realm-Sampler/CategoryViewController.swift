//
//  CategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var categoryTable: UITableView! // CategoryModelのデータを表示するためのTableView
    
    var categories: [CategoryModel] = [] // TableViewで表示する配列
    
    var updatingCategory: CategoryModel! // 更新するCategoryModel
    
    let realm = try! Realm()
    
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
    
    // Addボタンの処理
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    // CategoryModelを全件取得する
    func read() {
        categories = CategoryModel.loadAll()
        categoryTable.reloadData()
    }
    
    // 該当のCategoryを削除する
    func deleteModel(index id: Int) {
        try! realm.write {
            realm.delete(categories[id])
        }
    }
    
    func transition() {
        self.performSegueWithIdentifier("toAddCategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAddCategory" {
            let addCategory = segue.destinationViewController as! AddCategoryViewController
            addCategory.mode = .Update
            addCategory.updatingCategory = self.updatingCategory
        }
    }
}
