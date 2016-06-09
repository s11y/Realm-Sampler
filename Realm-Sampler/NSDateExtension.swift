//
//  NSDateExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/10.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

extension NSDate {
    func convertString() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.stringFromDate(self)
    }
}
