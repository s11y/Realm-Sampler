//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

// データを保存するのか更新するのか
enum SaveType {
    case create
    case update
}

class AddViewController: UIViewController {

    let realm = try! Realm()
    
    @IBOutlet var textField: UITextField! // ToDoの内容のUITextField
    
    @IBOutlet var dateTextField: UITextField! // ToDoの期限を決めるためのUITextField
    
    @IBOutlet var categoryTextField: UITextField! // ToDoのカテゴリーを決めるためのUITextField
    
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer! // 画面を触った時にキーボードを下げる
    
    var datePicker: UIDatePicker! // dateTextFieldで表示するUIDatePicker
    
    var categoryPicer: UIPickerView! // categoryTextFieldで表示するUIPickerView
    
    var categoryArray: [CategoryModel] = [] // UIPickerViewで表示するためのカテゴリーの配列
    
    var category: CategoryModel! // 保存するためのCategoryModelの変数
    
    var updatingTodo: ToDoModel! // 更新する際の元のデータとしてのCategoryModel
    
    var mode: SaveType = .create // データの作成か更新か決めるめたのenum
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        dateTextField.delegate = self
        textField.delegate = self
        
        self.setDatePicker() // datetextFieldにUIDatePickerを設定するためのメソッド -> AddViewExtension
        self.setGestureSeletor() // gestureRecognizerの処理先を指定 -> AddViewExtension
        self.setCategoryPicker() // categoryTextFieldにUIPickerViewを設定するためのメソッド -> AddViewExtension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readCategory()
        categoryPicer.selectedRow(inComponent: 0) // 初期値を設定
        self.convertCategory(selectedRow: 0) // 初期値を設定
        self.category = categoryArray[0] // 初期値を設定
        
        // SaveTyopeがpdateの時のみ、処理
        guard let todo = self.updatingTodo else { return }
        // 更新前のデータを、それぞれのUITextFieldに表示
        textField.text = todo.todo
        dateTextField.text = todo.due_date.convertDate()
        categoryTextField.text = todo.category?.category
        self.category = todo.category
        mode = .update // SaveTypeをupdateに設定
    }
    
    // Saveボタンを押したときの処理
    @IBAction func didSelectSave() {
        // それぞれのUITextFieldの中身が空じゃないことを確認
        let date: Date = datePicker.date
        guard let text = textField.text else { return }
        
        if categoryTextField.text?.isEmpty == false {
            // SaveTypeで保存か更新かを切り替え
            switch mode {
            case .create:
                self.create(todo: text, due_date: date, category_id: self.category) // 保存するためのメソッドにデータを渡す
            case .update:
                self.update(todo: text, due_date: date, category_id: self.category) // 更新するためのメソッドにデータを渡す
            }
            self.transition()
        }
    }
    
    // カテゴリーを全件取得
    func readCategory() {
        categoryArray = CategoryModel.loadAll()
    }
    
    func changedDueDate() {
        changeLabelDate(date: datePicker.date)
    }
    
    // 該当の日付をdateTextFieldに表示する
    func changeLabelDate(date: Date) {
        dateTextField.text = date.convertDate()
    }
    
    // データを保存するためのメソッド
    func create(todo content: String, due_date date: Date, category_id category: CategoryModel) {
        // それぞれのUITextFieldに入っているデータを元に、保存するデータを作成
        let todo = ToDoModel.create(content: content, category: category, dueDate: date)
        // 作成したデータを保存
        todo.save()
    }
    
    // データを更新するためのメソッド
    func update(todo content: String, due_date date: Date, category_id category: CategoryModel) {
        // それぞれのUITextFieldに入っているデータを元に、データを更新
        ToDoModel.update(model: updatingTodo, content: content, category: category, dueDate: date)
    }
    
    // 該当する順番のCategoryModelをcategoryTextFieldを表示する
    func convertCategory(selectedRow row: Int) {
        categoryTextField.text = categoryArray[row].category
    }
    
    // 戻る処理
    func transition() {
        self.navigationController?.popViewController(animated: true)
    }
}
