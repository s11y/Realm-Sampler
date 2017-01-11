//
//  UITableView+Extension.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2017/01/11.
//  Copyright © 2017年 ShinokiRyosei. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ : T.Type) where T: Reusable, T: NibLoadble {
        
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
