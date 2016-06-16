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
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var categoryTextField: UITextField!
    
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    var datePicker: UIDatePicker!
    
    var categoryPicer: UIPickerView!
    
    let categoryArray: [CategoryModel] = []
    
    var category: CategoryModel!
    
    var isCreate = true
    
    var updatingTodo: ToDoModel!
    
    var mode: RLMSaveMode = .Create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        dateTextField.delegate = self
        textField.delegate = self
        
        self.setDatePicker()
        self.setGestureSeletor()
        self.setCategoryPicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        categoryPicer.selectedRowInComponent(0)
        self.convertCategory(selectedRow: 0)
        
        guard let todo = self.updatingTodo else { return }
        textField.text = todo.todo
        dateTextField.text = todo.due_date.convertDate()
        categoryTextField.text = todo.category?.category
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
    
    func didSelectTapGesture() {
        dateTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    
    func changedDueDate() {
        changeLabelDate(datePicker.date)
    }
    
    func changeLabelDate(date: NSDate) {
        dateTextField.text = date.convertDate()
    }
    
    func create(todo content: String, due_date date: NSDate, category_id category: CategoryModel) {
        let todo = ToDoModel.create(content, category: category, dueDate: date)
        todo.save()
    }
    
    func update(todo content: String, due_date date: NSDate, category_id category: CategoryModel) {
        
        let realm = try! Realm()
        try! realm.write {
            ToDoModel.update(updatingTodo, content: content, category: category, dueDate: date)
        }
        
    }
    
    func convertCategory(selectedRow row: Int) {
        categoryTextField.text = categoryArray[row].category
    }
    
    func transition() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
