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
    
    @IBOutlet var todoTable: UITableView!
    
    @IBOutlet var segment: UISegmentedControl! // 全件取得か未完了ToDoかどちらを表示するか決めるためのUISegmentControl
    
    var todos: [ToDoModel] = []
    
    var todo: ToDoModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        todoTable.delegate = self
        todoTable.dataSource = self
        
        todoTable.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
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
        
        todoTable.estimatedRowHeight = 90
        todoTable.rowHeight = UITableViewAutomaticDimension
    }
    
    // 画面が表示される度に、Realmからデータを全件取得し、表示
    func read() {
        todos = ToDoModel.loadUndone()
        segment.selectedSegmentIndex = 0
        todoTable.reloadData()
    }
    
    // Addボタンを押したときの処理(画面遷移)
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            guard let updatingTodo = self.todo else { return }
            let addView = segue.destination as! AddViewController
            addView.updatingTodo = updatingTodo
        }
    }
    
    func transition() {
        self.performSegue(withIdentifier: "toAdd", sender: self)
    }
    
    // UISegmentControlの選択で、表示するデータの種類を切り替え
    func changeSegment(_ segment: UISegmentedControl) {
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
    
    // 初回起動時に、Realmにカテゴリーをセット
    func registerRealm() {
        let categories = ["家事", "勉強", "仕事"]
        for i in categories {
            let category = CategoryModel.create(newCategory: i)
            category.save()
        }
    }
}
