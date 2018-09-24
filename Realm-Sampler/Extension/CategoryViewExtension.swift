//
//  CategoryViewExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

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
