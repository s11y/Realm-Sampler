//
//  NSDateExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/10.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

extension NSDate {
    // TODO: Rename
    func convertString() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.stringFromDate(self)
    }
    
    func convertDate() -> String {
        let date_formatter: NSDateFormatter = NSDateFormatter()
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        return date_formatter.stringFromDate(self)
    }
}
