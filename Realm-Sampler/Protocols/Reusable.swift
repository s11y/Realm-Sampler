//
//  Reusable.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2017/01/11.
//  Copyright © 2017年 ShinokiRyosei. All rights reserved.
//

import UIKit

protocol Reusable {
    
    static var defaultReuseIdentifier: String { get }
}


extension Reusable where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        
        return String(describing: self)
    }
}
