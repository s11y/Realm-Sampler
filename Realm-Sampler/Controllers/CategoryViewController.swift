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

    // CategoryModelのデータを表示するためのTableView
    @IBOutlet var tableView: UITableView! {
        didSet {

            tableView.register(CategoryCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var categories: [Category] = [] // TableViewで表示する配列
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        categories = Category.loadAll()
        tableView.reloadData()
    }
    
    // Addボタンの処理
    @IBAction func didSelectAdd() {
        self.performSegue(withIdentifier: "toAddCategory", sender: self)
    }
    
    // 該当のCategoryを削除する
    func deleteModel(index id: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(categories[id])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCategory" {
            guard let category = sender as? Category else { return }
            let addCategory = segue.destination as! AddCategoryViewController
            addCategory.mode = .update(category: category)
        }
    }
}

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Swipeの時の、Deleteボタン
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { [weak self] action, indexPath in
            self?.categories.remove(at: indexPath.row) // 配列から削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade) // TableViewから削除
            self?.deleteModel(index: indexPath.row) // 該当のデータをデータベースから削除
        }

        delete.backgroundColor = UIColor.red

        // Swipeの時の、Editボタン
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] action, indexPath in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: "toAddCategory", sender: self.categories[indexPath.row])
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

