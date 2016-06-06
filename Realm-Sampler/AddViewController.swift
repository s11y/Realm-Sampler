//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSave() {
        self.create(todo: textField.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func create(todo content: String) {
        let todo = ToDoModel.create()
        todo.todo = content
        todo.due_date = datePicker.date
        todo.save()
    }
}
