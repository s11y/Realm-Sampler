//
//  CategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! // CategoryModelのデータを表示するためのTableView
    
    var categories: [CategoryModel] = [] // TableViewで表示する配列
    
    var updatingCategory: CategoryModel! // 更新するCategoryModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.read()
    }
    
    // Addボタンの処理
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    // CategoryModelを全件取得する
    func read() {
        categories = CategoryModel.loadAll()
        tableView.reloadData()
    }
    
    // 該当のCategoryを削除する
    func deleteModel(index id: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(categories[id])
        }
    }
    
    func transition() {
        self.performSegue(withIdentifier: "toAddCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCategory" {
            let addCategory = segue.destination as! AddCategoryViewController
            addCategory.mode = .update(category: updatingCategory)
        }
    }
}

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Swipeの時の、Deleteボタン
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            self.categories.remove(at: indexPath.row) // 配列から削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade) // TableViewから削除
            self.deleteModel(index: indexPath.row) // 該当のデータをデータベースから削除
        }

        delete.backgroundColor = UIColor.red

        // Swipeの時の、Editボタン
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            self.updatingCategory = self.categories[index.row] // データを保存するための変数に代入
            self.transition() // 画面遷移
        }

        return [delete, edit]
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


}


extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        cell.categoryLabel.text = categories[indexPath.row].category

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}

