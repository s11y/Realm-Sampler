//
//  AddViewExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation
import UIKit

extension AddViewController {
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.changedDueDate), forControlEvents: .ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        dateTextField.inputView = datePicker
    }
    
    func setCategoryPicker() {
        categoryPicer = UIPickerView()
        categoryPicer.delegate = self
        categoryPicer.dataSource = self
        
        categoryTextField.inputView = categoryPicer
    }
    
    func setGestureSeletor() {
        gestureRecognizer.addTarget(self, action: #selector(self.didSelectTapGesture))
    }
}
