//
//  AddCategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var categoryTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSave() {
        self.create()
    }
    
    func create() {
        guard let text = categoryTextField.text else { return }
        let category = CategoryModel.create(newCategory: text)
        category.save()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
