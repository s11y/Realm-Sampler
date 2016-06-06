//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate, UIToolbarDelegate {
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var dateTextField: UITextField!
    
    var datePicker: UIDatePicker!
    
    var toolBar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        textField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate), forControlEvents: .ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        dateTextField.inputView = datePicker
        
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: #selector(self.tappedToolBarBtn(_:)))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .Plain, target: self, action: #selector(self.tappedToolBarBtnToday(_:)))
        
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        
        textField.inputAccessoryView = toolBar
    
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
    
    func changedDueDate() {
        
    }
    
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        datePicker.date = NSDate()
        changeLabelDate(NSDate())
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}
