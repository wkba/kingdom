//
//  testViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/07.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UITextFieldDelegate {
    
    var myRootRef: Firebase!
    var num : Int = 0
    
    
    
    
    var NumMenber = [String]()


    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var TextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nameにラベルを設定
        self.nameLabel.text = "Guest3"
        // Return時のイベントをハンドルするために登録
        self.inputField.delegate = self

        // Firebaseへ接続
        self.myRootRef = Firebase(url: "https://onigokko.firebaseio.com/chat1/posts")
        // Child追加時のイベントハンドラ
        self.myRootRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                     if let teamName = snapshot.value.objectForKey("teamName") as? String {
                         if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                            if let DeadOrAlive = snapshot.value.objectForKey("DeadOrAlive") as? String {
                                if let message = snapshot.value.objectForKey("message") as? String {
                                    self.TextView.text = "\(self.TextView.text)\n\(teamName):\(teamPosition) -> \( message ) "
                                }
                            }
                        }
                }
            
            
            
            
            self.NumMenber.append("teamName")

        })
        
        // 接続直後に呼び出されるイベントハンドラ
        self.myRootRef.observeEventType(.Value, withBlock: { snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            

                    if let teamName = snapshot.value.objectForKey("teamName") as? String {
                        if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                            if let DeadOrAlive = snapshot.value.objectForKey("DeadOrAlive") as? String {
                                if let message = snapshot.value.objectForKey("message") as? String {
                                    self.TextView.text = "\(self.TextView.text)\n\(teamName):\(teamPosition) -> \( message )"
                                }
                            }
                        }
            }
        })
       
    
    }
    
    
    
    
  
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // キーボードを隠す
        textField.resignFirstResponder()
        // 入力内容を登録
        self.myRootRef.childByAutoId().setValue([
            "teamName": self.nameLabel.text,
            "teamPosition": "gi",
            "DeadOrAlive": "dead",
            "message":textField.text
            ])
        // TextFieldの入力内容をクリア
        textField.text = ""

        
        return true
    }
}
