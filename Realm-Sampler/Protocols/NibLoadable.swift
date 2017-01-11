//
//  NibLoadable.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2017/01/11.
//  Copyright © 2017年 ShinokiRyosei. All rights reserved.
//

import UIKit

protocol NibLoadble: class {
    
    static var nibName: String { get }
}

extension NibLoadble where Self: UIView {
    
    static var nibName: String {
        
        return String(describing: self)
    }
}
