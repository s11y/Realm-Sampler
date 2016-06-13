//
//  CategoryModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/14.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CategoryModel: Object {
    
    static let realm = try! Realm()
    
    dynamic private var id: Int = 0
    dynamic var category: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
}
