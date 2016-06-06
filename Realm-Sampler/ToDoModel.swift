//
//  ToDoModel.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoModel: Object {
    dynamic var id: Int = 0
    dynamic var todo: String = ""
    dynamic var category: Int = 0
    dynamic var due_date: NSDate!
//    dynamic var 
    
}
