//
//  ViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var segment: UISegmentedControl! // 全件取得か未完了ToDoかどちらを表示するか決めるためのUISegmentControl
    
    var todos: [ToDoModel] = []
    
    var todo: ToDoModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TodoCell.self)
        
        segment.addTarget(self, action: #selector(self.changeSegment(_:)), for: .touchUpInside) // UISegmentControlのtargetを指定
        
        // 初回起動時に処理
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstLaunch") {
            self.registerRealm()
            defaults.set(false, forKey: "firstLaunch") // 処理後 falseをセット
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.read()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // 画面が表示される度に、Realmからデータを全件取得し、表示
    func read() {
        todos = ToDoModel.loadUndone()
        segment.selectedSegmentIndex = 0
        tableView.reloadData()
    }
    
    // Addボタンを押したときの処理(画面遷移)
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            guard let todo = self.todo else { return }
            let addViewController = segue.destination as! AddViewController
            addViewController.mode = .update(todo: todo)
        }
    }
    
    func transition() {
        self.performSegue(withIdentifier: "toAdd", sender: self)
    }
    
    // UISegmentControlの選択で、表示するデータの種類を切り替え
    @objc func changeSegment(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            todos = ToDoModel.fetch(FetchType: .undone)
        case 1:
            todos = ToDoModel.fetch(FetchType: .all)
        default:
            break
        }
        tableView.reloadData()
    }
    
    // 初回起動時に、Realmにカテゴリーをセット
    func registerRealm() {
        let categories = ["家事", "勉強", "仕事"]
        for i in categories {
            let category = CategoryModel(newCategory: i)
            category.save()
        }
    }

}
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // スワイプでDeleteボタンを表示
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            tableView.isEditing = false
            // 該当のデータを定数に代入
            let item = self.realm.objects(ToDoModel.self)[indexPath.row]
            // 該当のデータをデータベースを削除する
            try! self.realm.write {
                self.realm.delete(item
                )
            }
            // UITableViewから削除する
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        delete.backgroundColor = UIColor.red

        // スワイプでDoneボタンを表示
        let done = UITableViewRowAction(style: .normal, title: "DONE") { (action, indexPath) in
            // 該当のデータを定数に代入
            let item = self.realm.objects(ToDoModel.self)[indexPath.row]
            //データベースのデータを更新する
            try! self.realm.write({
                item.isDone = 1 // isDoneの値を1に変更
            })
        }

        done.backgroundColor = UIColor.green

        // スワイプでEditボタンを表示
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            // AddViewに渡すデータを代入
            self.todo = self.todos[indexPath.row]
            self.transition() // 画面遷移
        }

        return [delete, done, edit]
    }
}


extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: TodoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        let item = todos[indexPath.row]
        cell.duedateLabel.text = item.dueDate.convertDate()
        cell.todoLabel.text = item.todo

        return cell
    }
}
