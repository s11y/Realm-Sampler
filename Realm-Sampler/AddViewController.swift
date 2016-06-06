//
//  AddViewController.swift
//  Realm-Sampler
//
//  Created by ShinokiRyosei on 2016/06/07.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func create(todo content: String) {
        let todo = ToDoModel.create()
        todo.todo = content
        todo.save()
    }
}
