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
    
    @IBOutlet var categoryTextField: UITextField! // カテゴリーの内容を記入するUITextField
    
    var updatingCategory: CategoryModel! // 更新の際のデータ
    
    var mode: RLMSaveMode = .Create // 更新か作成か
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 更新の際に、更新前のカテゴリーをUITextFieldに表示
        if mode == .Update {
            categoryTextField.text = updatingCategory.category
        }
    }
    
    // Saveボタンの処理
    @IBAction func didSelectSave() {
        //
        guard let text = categoryTextField.text else { return }
        switch mode {
        case .Create:
            self.create(categoryContent: text)
        case .Update:
            self.update(categoryContent: text)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func create(categoryContent text: String) {
        let category = CategoryModel.create(newCategory: text)
        category.save()
        
    }
    
    func update(categoryContent text: String) {
        CategoryModel.update(model: updatingCategory, content: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
