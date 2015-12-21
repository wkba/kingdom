//
//  firstView.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/01.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit



class firstView: UIViewController{
    
    
    @IBOutlet weak var RunAway: UILabel!
    @IBOutlet weak var send_info_button: UIButton!
    @IBOutlet weak var pickView: UIPickerView!


    var graphView:PieGraphView!;
    var statusLabel = UILabel(frame: CGRectMake(0, 0, 100, 20));

    
    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":1,"color":UIColor.redColor()])
        params.append(["value":1,"color":UIColor.blueColor()])
        params.append(["value":1,"color":UIColor.greenColor()])
       // params.append(["value":10,"color":UIColor.yellowColor()])
        
        graphView = PieGraphView(frame: CGRectMake(0, (h-w)/2, w, w), params: params)
        self.view.addSubview(graphView)
        graphView.startAnimating()

        
 
     
        
        
        
        statusLabel = UILabel(frame: CGRectMake(w / 2, h / 2 , 200, 40));
        statusLabel.center = CGPointMake(w/2, h / 2);//表示位置
        statusLabel.font = UIFont.systemFontOfSize(18);//文字サイズ
        statusLabel.textAlignment = NSTextAlignment.Center
        statusLabel.textColor = UIColor.whiteColor()////文字色
        // everyLabel.backgroundColor = UIColor.whiteColor()////背景色
        statusLabel.text = "Run Away!!";
        self.view.addSubview(statusLabel);

    
        
        var timer = NSTimer();
        timer = NSTimer.scheduledTimerWithTimeInterval(1.800,target:self,selector:Selector("URL_move"),
            userInfo: nil, repeats: false);
        
        
        var timerChageLable = NSTimer();
        timer = NSTimer.scheduledTimerWithTimeInterval(160.0,target:self,selector:Selector("ChageLabel"),
            userInfo: nil, repeats: false);
        
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func URL_move(){
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "MainViewController" ) as! UIViewController
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    
    func ChageLabel(){
        statusLabel.text="もうすぐはじまります。"
    }
   
 
    
}