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
    
    let categoryArray: [String] = ["勉強", "家事", "プログラミング"]
    
    var category = 0
    
    var isCreate = true
    
    var updatingTodo: ToDoModel!
    
    var mode: RLMSaveMode = .Create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        dateTextField.delegate = self
        textField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate), forControlEvents: .ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        dateTextField.inputView = datePicker
        
        gestureRecognizer.addTarget(self, action: #selector(self.didSelectTapGesture))
        
        categoryPicer = UIPickerView()
        categoryPicer.delegate = self
        categoryPicer.dataSource = self
        
        categoryTextField.inputView = categoryPicer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        categoryPicer.selectedRowInComponent(category)
        self.convertCategory(selectedRow: category)
        
        guard let todo = self.updatingTodo else { return }
        textField.text = todo.todo
        dateTextField.text = todo.due_date.convertDate()
        categoryTextField.text = categoryArray[todo.category]
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
    
    func create(todo content: String, due_date date: NSDate, category_id category: Int) {
        let todo = ToDoModel.create(content, category: category, dueDate: date)
        todo.save()
    }
    
    func update(todo content: String, due_date date: NSDate, category_id category: Int) {
        let todo = ToDoModel.update(content, category: category, dueDate: date)
        todo.save()
        
    }
    
    func convertCategory(selectedRow row: Int) {
        categoryTextField.text = categoryArray[row]
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.convertCategory(selectedRow: row)
        self.category = row
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
