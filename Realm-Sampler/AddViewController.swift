//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

enum RLMSaveMode {
    case Create
    case Update
}

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textField: UITextField! // ToDoの内容のUITextField
    
    @IBOutlet var dateTextField: UITextField! // ToDoの期限を決めるためのUITextField
    
    @IBOutlet var categoryTextField: UITextField! // ToDoのカテゴリーを決めるためのUITextField
    
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer! // 画面を触った時にキーボードを下げる
    
    var datePicker: UIDatePicker!
    
    var categoryPicer: UIPickerView!
    
    var categoryArray: [CategoryModel] = []
    
    var category: CategoryModel!
    
    var isCreate = true
    
    var updatingTodo: ToDoModel!
    
    var mode: RLMSaveMode = .Create // データの作成か更新か決めるめたのenum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        dateTextField.delegate = self
        textField.delegate = self
        
        self.setDatePicker() // datetextFieldにUIDatePickerを設定するためのメソッド -> AddViewExtension
        self.setGestureSeletor() // gestureRecognizerの処理先を指定 -> AddViewExtension
        self.setCategoryPicker() // categoryTextFieldにUIPickerViewを設定するためのメソッド -> AddViewExtension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.read()
        categoryPicer.selectedRowInComponent(0)
        self.convertCategory(selectedRow: 0)
        self.category = categoryArray[0]
        
        guard let todo = self.updatingTodo else { return }
        textField.text = todo.todo
        dateTextField.text = todo.due_date.convertDate()
        categoryTextField.text = todo.category?.category
        self.category = todo.category
        mode = .Update
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSave() {
        guard let date: NSDate = datePicker.date else { return }
        guard let text = textField.text else { return }
        
        if categoryTextField.text?.isEmpty == false {
            switch mode {
            case .Create:
                self.create(todo: text, due_date: date, category_id: self.category)
            case .Update:
                self.update(todo: text, due_date: date, category_id: self.category)
            }
            self.transition()
        }
    }
    
    func read() {
        categoryArray = CategoryModel.loadAll()
    }
    
    func changedDueDate() {
        changeLabelDate(datePicker.date)
    }
    
    func changeLabelDate(date: NSDate) {
        dateTextField.text = date.convertDate()
    }
    
    //
    func create(todo content: String, due_date date: NSDate, category_id category: CategoryModel) {
        let todo = ToDoModel.create(content, category: category, dueDate: date)
        todo.save()
    }
    
    func update(todo content: String, due_date date: NSDate, category_id category: CategoryModel) {
        ToDoModel.update(updatingTodo, content: content, category: category, dueDate: date)
    }
    
    func convertCategory(selectedRow row: Int) {
        categoryTextField.text = categoryArray[row].category
    }
    
    func transition() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
