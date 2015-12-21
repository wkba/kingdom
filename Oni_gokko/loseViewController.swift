//
//  loseViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/14.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit
import Social


class loseViewController: UIViewController {
    var myRootRef_delete: Firebase!
    
   // var Team_Name : String = ""
   // var Team_Position : String =  ""
    var RoomID : String = ""
    var timer = NSTimer();

    
    
    
    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        //delete whereAreYou
        self.myRootRef_delete = Firebase (url: "https://onigokko.firebaseio.com/" + RoomID )
        self.myRootRef_delete.setValue(nil)
        
         timer =  NSTimer.scheduledTimerWithTimeInterval(1.0 ,target:self,selector:Selector("setRoot"),userInfo: nil, repeats: false);
        
        
        var tweetButton: UIButton = UIButton()
        var facebookButton: UIButton = UIButton()
        
        tweetButton.setTitle("Twitter", forState: .Normal)
        tweetButton.frame = CGRectMake(0, 0, 300, 50)
        tweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //  tweetButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        tweetButton.layer.position = CGPoint(x: self.view.frame.midX, y: self.h - 80)
        tweetButton.addTarget(self, action: "onClickTweetButton:", forControlEvents:.TouchUpInside)
        
        facebookButton.setTitle("Facebook", forState: .Normal)
        facebookButton.frame = CGRectMake(0, 0, 300, 50)
        facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        // facebookButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        facebookButton.layer.position = CGPoint(x: self.view.frame.midX, y: self.h - 120)
        facebookButton.addTarget(self, action: "onClickFacebookButton:", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(tweetButton)
        self.view.addSubview(facebookButton)
        
        
        
    }
    
    
    
    func onClickTweetButton(sender: UIButton) {
        
        let text = "みんなでリアルおにごっこしよーぜ　https://goo.gl/tuQjPZ"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        
        self.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    
    
    func onClickFacebookButton(sender: UIButton) {
        
        let text = "みんなでリアルおにごっこしよーぜ　https://goo.gl/tuQjPZ"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        
        self.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    
    func setRoot(){
        //delete whereAreYou
        self.myRootRef_delete = Firebase (url: "https://onigokko.firebaseio.com/" + RoomID )
        self.myRootRef_delete.setValue(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //Team_Name = appDelegate.ViewVal
        //Team_Position =  appDelegate.ViewVal1
        RoomID = appDelegate.ViewVal6
        
        
 
        
    }
}

