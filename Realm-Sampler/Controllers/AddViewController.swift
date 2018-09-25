//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    // データを保存するのか更新するのか
    enum SaveType {
        case create
        case update(todo: ToDoModel)
    }

    // ToDoの内容のUITextField
    @IBOutlet var textField: UITextField! {

        didSet {
            textField.delegate = self
        }
    }

    // ToDoの期限を決めるためのUITextField
    @IBOutlet var dateTextField: UITextField! {

        didSet {
            dateTextField.delegate = self
        }
    }

    // ToDoのカテゴリーを決めるためのUITextField
    @IBOutlet var categoryTextField: UITextField! {

        didSet {
            categoryTextField.delegate = self
        }
    }
    
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer! // 画面を触った時にキーボードを下げる
    
    var datePicker: UIDatePicker! // dateTextFieldで表示するUIDatePicker
    
    var categoryPicer: UIPickerView! // categoryTextFieldで表示するUIPickerView
    
    var categoryArray: [CategoryModel] = [] // UIPickerViewで表示するためのカテゴリーの配列
    
    var category: CategoryModel! // 保存するためのCategoryModelの変数

    // データの作成か更新か決めるめたのenum
    var mode: SaveType = .create
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.setDatePicker() // datetextFieldにUIDatePickerを設定するためのメソッド
        self.setGestureSeletor() // gestureRecognizerの処理先を指定
        self.setCategoryPicker() // categoryTextFieldにUIPickerViewを設定するためのメソッド
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryArray = CategoryModel.loadAll()

        switch mode {
        case .update(let todo):
            // 更新前のデータを、それぞれのUITextFieldに表示
            textField.text = todo.todo
            dateTextField.text = todo.dueDate.convertDate()
            categoryTextField.text = todo.category?.category
            self.category = todo.category

        default:
            categoryPicer.selectedRow(inComponent: 0) // 初期値を設定
            self.convertCategory(selectedRow: 0) // 初期値を設定
            self.category = categoryArray[0] // 初期値を設定
        }

    }
    
    // Saveボタンを押したときの処理
    @IBAction func didSelectSave() {
        // それぞれのUITextFieldの中身が空じゃないことを確認
        let date: Date = datePicker.date
        guard let text = textField.text else { return }
        
        if categoryTextField.text?.isEmpty == false {
            // SaveTypeで保存か更新かを切り替え
            switch mode {
            case .create:
                self.create(todo: text, due_date: date, categoryId: self.category) // 保存するためのメソッドにデータを渡す
            case .update(let todo):
                ToDoModel.update(model: todo, content: text, category: category, dueDate: date)
            }
            self.transition()
        }
    }
    
    @objc func changedDueDate(_ sender: UIDatePicker) {
        dateTextField.text = sender.date.convertDate()
    }
    
    // データを保存するためのメソッド
    func create(todo content: String, due_date date: Date, categoryId category: CategoryModel) {
        // それぞれのUITextFieldに入っているデータを元に、保存するデータを作成
        let todo = ToDoModel(content: content, category: category, dueDate: date)
        // 作成したデータを保存
        todo.save()
    }
    
    // 該当する順番のCategoryModelをcategoryTextFieldを表示する
    func convertCategory(selectedRow row: Int) {
        categoryTextField.text = categoryArray[row].category
    }
    
    // 戻る処理
    func transition() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddViewController: UIPickerViewDelegate  {
    // UIDatePickerをdateTextFieldを追加
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate(_:)), for: .valueChanged)
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime

        dateTextField.inputView = datePicker
    }

    // UIPickerViewをcategoryTextFieldを追加
    func setCategoryPicker() {
        categoryPicer = UIPickerView()
        categoryPicer.delegate = self
        categoryPicer.dataSource = self

        categoryTextField.inputView = categoryPicer
    }

    // 画面上のUIGestureRecognizerのTargetを決める
    func setGestureSeletor() {
        gestureRecognizer.addTarget(self, action: #selector(self.didSelectTapGesture))
    }

    // 画面を触った時に、キーボードを下げる
    @objc func didSelectTapGesture() {
        dateTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.convertCategory(selectedRow: row)
        self.category = categoryArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].category
    }
}

extension AddViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
}


extension AddViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

