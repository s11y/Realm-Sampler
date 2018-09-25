//
//  AddCategoryViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController { // AddCategoryViewControllerにUITextFieldDelegateを継承

    enum SaveType {

        case create
        case update(category: CategoryModel)
    }
    
    @IBOutlet var categoryTextField: UITextField! // カテゴリーの内容を記入するUITextField
    
    var updatingCategory: CategoryModel? // 更新の際のデータ
    
    var mode: SaveType = .create // 更新か作成か
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 更新の際に、更新前のカテゴリーをUITextFieldに表示
        switch mode {
        case .update(let category):
            categoryTextField.text = category.category
        default:
            break
        }
    }
    
    // Saveボタンの処理
    @IBAction func didSelectSave() {
        // categoryTextFieldに文字が記入されているかチェック
        guard let text = categoryTextField.text else { return }
        
        // 更新か作成かで呼び出すメソッドを切り替え
        switch mode {
        case .create:
            // CategoryModelのcreateメソッドを使って保存するためのデータを作成
            let category = CategoryModel(newCategory: text)
            // 作成したデータを保存
            category.save()
        case .update:
            // categoryTextFieldの内容を使って、データを更新
            guard let category = updatingCategory else { return }
            CategoryModel.update(model: category, content: text)
        }
        // 画面遷移
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddCategoryViewController: UITextFieldDelegate {
    
    // Returnキーでキーボードを下げる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
