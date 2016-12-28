//
//  AddViewExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation
import UIKit

extension AddViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    // UIDatePickerをdateTextFieldを追加
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate), for: .valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
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
    func didSelectTapGesture() {
        dateTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].category
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.convertCategory(selectedRow: row)
        self.category = categoryArray[row]
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
