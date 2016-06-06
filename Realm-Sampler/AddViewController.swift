//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var categoryTextField: UITextField!
    
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    var datePicker: UIDatePicker!
    
    var categoryPicer: UIPickerView!
    
    let categoryArray: [String] = ["勉強", "家事", "プログラミング"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        dateTextField.delegate = self
        textField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate), forControlEvents: .ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        dateTextField.inputView = datePicker
        
        gestureRecognizer.addTarget(self, action: #selector(self.didSelectTapGesture))
        
        categoryPicer = UIPickerView()
        categoryPicer.delegate = self
        categoryPicer.dataSource = self
        
        categoryTextField.inputView = categoryPicer
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSave() {
        guard let date: NSDate = datePicker.date else { return }
        guard let text = textField.text else { return }
        
        self.create(todo: text, due_date: date)
    }
    
    func didSelectTapGesture() {
        print("add target")
        dateTextField.resignFirstResponder()
    }
    
    func changedDueDate() {
        print("change Due Date")
        changeLabelDate(datePicker.date)
    }
    
    func changeLabelDate(date: NSDate) {
        dateTextField.text = dateToString(date)
    }
    
    func dateToString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let comps: NSDateComponents = calender.components([NSCalendarUnit.Year ,NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday], fromDate: date)
        
        let date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays: [AnyObject]  = [ "日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日（\(weekdays[comps.weekday])） "
        
        return date_formatter.stringFromDate(date)
    }
    
    
    func create(todo content: String, due_date date: NSDate) {
        let todo = ToDoModel.create()
        todo.todo = content
        todo.due_date = date
        todo.save()
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
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
