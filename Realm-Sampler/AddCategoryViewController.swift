//
//  AddCategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var categoryTextField: UITextField!
    
    var updatingCategory: CategoryModel!
    
    var mode: RLMSaveMode = .Create

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == .Update {
            categoryTextField.text = updatingCategory.category
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSave() {
        guard let text = categoryTextField.text else { return }
        switch mode {
        case .Create:
            self.create(categoryContent: text)
        case .Update:
            self.update(categoryContent: text)
        }
        self.navigationController?.popViewControllerAnimated(true) 
    }
    
    func create(categoryContent text: String) {
        let category = CategoryModel.create(newCategory: text)
        category.save()
        
    }
    
    func update(categoryContent text: String) {
            CategoryModel.update(updatingCategory, content: text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
