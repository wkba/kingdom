//
//  TopController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/02.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//


import UIKit
import Social




class TopController: UIViewController {
    
    

    
    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
    // let backColor:UIColor = UIColor(red:31/255.0, green:36/255.0, blue:38/255.0,alpha:1.0)
    
    
    var logoImageView: UIImageView!
    var titlelogoImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

/*
        
        let logo = UIImage(named:"newLogo.png")
        logoImageView = UIImageView(image:logo)
       // imageView.alpha = 0.035
        logoImageView.frame.size.width = 100
        logoImageView.frame.size.height = 100
        logoImageView.center.x = w/2
        logoImageView.center.y = h/2
        self.view.addSubview(logoImageView)
*/

        var tweetButton: UIButton = UIButton()
        var facebookButton: UIButton = UIButton()
        
        tweetButton.setTitle("Twitter", forState: .Normal)
        tweetButton.frame = CGRectMake(0, 0, 300, 50)
        tweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      //  tweetButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        tweetButton.layer.position = CGPoint(x: self.view.frame.midX, y: 80)
        tweetButton.addTarget(self, action: "onClickTweetButton:", forControlEvents:.TouchUpInside)
        
        facebookButton.setTitle("Facebook", forState: .Normal)
        facebookButton.frame = CGRectMake(0, 0, 300, 50)
        facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
       // facebookButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        facebookButton.layer.position = CGPoint(x: self.view.frame.midX, y: 120)
        facebookButton.addTarget(self, action: "onClickFacebookButton:", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(tweetButton)
        self.view.addSubview(facebookButton)
        
        let titlelogo = UIImage(named:"titleLogo.png")
        self.titlelogoImageView = UIImageView(image:titlelogo)
        // imageView.alpha = 0.035
        self.titlelogoImageView.frame.size.width = 170
        self.titlelogoImageView.frame.size.height = 60
        
        self.titlelogoImageView.center.x = self.w/2
        self.titlelogoImageView.center.y = self.h/2
        self.view.addSubview(self.titlelogoImageView)
        
        makeAlert()
        

        

        
    }
    
    func makeAlert(){
        var alert = UIAlertView()
        alert.title = "ゲーム利用に関しての確認"
        alert.message = "本アプリ内で使用されるGPS情報と勝ち負けの判定結果は、ゲーム進行のためサーバに転送されます。\n尚、ゲーム終了時にサーバから削除されます。受諾していただける方のみ”許可”を押してください"
        alert.addButtonWithTitle("許可")
        alert.show()
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        //少し縮小するアニメーション
        UIView.animateWithDuration(0.3,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion: { (Bool) in
                
        })
        
        //拡大させて、消えるアニメーション
        UIView.animateWithDuration(0.2,
            delay: 1.3,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                self.logoImageView.alpha = 0
            }, completion: { (Bool) in
                self.logoImageView.removeFromSuperview()
                let titlelogo = UIImage(named:"titleLogo.png")
                self.titlelogoImageView = UIImageView(image:titlelogo)
                // imageView.alpha = 0.035
                self.titlelogoImageView.frame.size.width = 170
                self.titlelogoImageView.frame.size.height = 60
                
                self.titlelogoImageView.center.x = self.w/2
                self.titlelogoImageView.center.y = self.h/2
                self.view.addSubview(self.titlelogoImageView)
        
                
        })
        
        /*
        UIView.animateWithDuration(3,
            animations: { () -> Void in
            self.view.backgroundColor = self.backColor
        })
*/
   
    }
    */
 
}

