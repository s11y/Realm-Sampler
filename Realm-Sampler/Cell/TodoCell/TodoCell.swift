//
//  TodoCell.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell, Reusable, NibLoadble {
    
    @IBOutlet var todoLabel: UILabel!
    
    @IBOutlet var duedateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
