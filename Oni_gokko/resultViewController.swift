//
//  consultViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/02.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit
import Alamofire


class resultViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!

    @IBOutlet weak var resultMessage: UIScrollView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 角に丸みをつける.
        resultMessage.layer.masksToBounds = true
        // 丸みのサイズを設定する.
        resultMessage.layer.cornerRadius = 20.0

        
     
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

