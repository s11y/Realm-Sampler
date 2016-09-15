//
//  NSDateExtension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/10.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

extension Date {
    // DateをString型に変換
    func convertDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
