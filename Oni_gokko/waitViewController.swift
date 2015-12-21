//
//  waitViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/05.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import AudioToolbox



class waitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var graphView:howManyPeople!;
    var myRootRef: Firebase!
    var myRootRef_uel_change: Firebase!


    let Teams:[String] = ["魏", "呉", "蜀"]
    let Positions:[String] = ["王", "軍師", "武人", "平民1","平民2","平民3","平民4"]

    var MyTeam="蜀"
    var MyPosition="武人"
    
    
    var gps_info:String="test"
    var RoomID:String = "test"
    
    
    var timer = NSTimer();
    var timer_gps = NSTimer();
    var timer_changeLabel = NSTimer();


    var NumMenber = [String]()
    var SystemNumber :Int = 0
    
    var AllNumber : Int = 0
    var MyTeamNumber :Int = 0
    
    var flagInsert : Int = 0
    
    var MyNumber : Int = 0
    
    var flag_myRootRef_allnumber = 0
    
    var everyLabel = UILabel(frame: CGRectMake(0, 0, 100, 20))
    var myButton = UIButton()
    
    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
   
    
    //GPS
    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
   
    
    @IBAction func test(sender: AnyObject) {
        self.myRootRef_uel_change.childByAutoId().setValue([
            "change": "yes",
            ])
    }

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 1000
        lm.startUpdatingLocation()
        
        
        
        let numSize = (11/12 * 7/10 / 2) * w - 30
        var tenPlace = UIImage(named:"zero.png")
        var tenPlaceView = UIImageView(image:tenPlace)
        tenPlaceView.frame = CGRectMake(1/2 * w - 4 - numSize,  h/2 - numSize, numSize, numSize * 2)
        self.view.addSubview(tenPlaceView)
        
        var onePlace = UIImage(named:"zero.png")
        var onePlaceView = UIImageView(image:onePlace)
        onePlaceView.frame = CGRectMake(1/2 * w + 4 ,  h/2 - numSize, numSize, numSize * 2)
        self.view.addSubview(onePlaceView)
        
        
        
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,200,40)
        //myButton.backgroundColor = UIColor.redColor()
        //myButton.layer.masksToBounds = true
        myButton.setTitle("この人数ではじめる", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.setTitle("この人数ではじめる", forState: UIControlState.Highlighted)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        //myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: w/2, y:(h - w) / 2 * 3 / 2 + w)
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view.addSubview(myButton)
        self.myButton.hidden = true

        
        
        everyLabel = UILabel(frame: CGRectMake(w / 2, (h - w) / 2 * 3 / 2 + w, 100, 20));
        everyLabel.center = CGPointMake(w/2, (h - w) / 2 * 3 / 2 + w);//表示位置
        everyLabel.font = UIFont.systemFontOfSize(15);//文字サイズ
        everyLabel.textAlignment = NSTextAlignment.Center
        everyLabel.textColor = UIColor.whiteColor()////文字色
       // everyLabel.backgroundColor = UIColor.whiteColor()////背景色
        everyLabel.text = "Please Wait...";
        self.view.addSubview(everyLabel);
        



        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":1,"color":UIColor.redColor()])

        graphView = howManyPeople(frame: CGRectMake(0, (h-w)/2, w, w), params: params)
        self.view.addSubview(graphView)
        graphView.startAnimating()
        
        
        timer_gps = NSTimer.scheduledTimerWithTimeInterval(3 ,target:self,selector:Selector("senderInfo"),
            userInfo: nil, repeats: false);
        timer_changeLabel = NSTimer.scheduledTimerWithTimeInterval(15,target:self,selector:Selector("changeLabel"),
            userInfo: nil, repeats: false);
    }




    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        MyTeamNumber = AllNumber / 3
        switch MyTeam{
        case "魏" :
            switch (AllNumber % 3) {
            case 2 : self.MyTeamNumber = self.MyTeamNumber + 1
            case 1 : self.MyTeamNumber = self.MyTeamNumber + 1
            default: break
            }
        case "呉" :
            switch (AllNumber % 3) {
            case 2 : self.MyTeamNumber = self.MyTeamNumber + 1
            default: break
            }
        default : break
        }
        
        
        appDelegate.ViewVal = MyTeam
        appDelegate.ViewVal1 = MyPosition
        appDelegate.ViewVal2 = AllNumber
        appDelegate.ViewVal3 = MyTeamNumber
        appDelegate.ViewVal4 = gps_info
        appDelegate.ViewVal5 = MyNumber
        appDelegate.ViewVal6 = RoomID

        
    }
    
    func senderInfo(){
        self.myRootRef = Firebase (url: ("https://onigokko.firebaseio.com/" + RoomID + "/ID_wait"))
        
        
   
        if(self.flag_myRootRef_allnumber == 0){
            
            
            self.myRootRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            self.NumMenber.append("teamName")
            self.AllNumber = self.AllNumber + 1
            println("waitView :L196 :Value :ChildAdded :AllNumber : \(self.AllNumber)")
            self.setNumber()
            self.flag_myRootRef_allnumber == 1
            })
        
        }

        
        self.myRootRef.observeEventType(.Value, withBlock: { snapshot in
             if(self.flagInsert == 0){
               
                
                println("waitView:Value: AllNumber: " + "\(self.AllNumber)")

                //self.MyTeam = self.Teams[ (self.AllNumber - 1) % 3]
                //self.MyPosition = self.Positions[(self.AllNumber - 1) / 3]
                
                self.MyNumber = self.AllNumber
                self.flagInsert = 1
                
            }
            if(self.MyNumber == 0) {
                self.MyTeam = self.Teams[ (self.MyNumber) % 3]
                self.MyPosition = self.Positions[(self.MyNumber) / 3]
            }else{
                self.MyTeam = self.Teams[ (self.MyNumber - 1) % 3]
                self.MyPosition = self.Positions[(self.MyNumber - 1) / 3]
            }
            
            println("waitView: L225 :Value :myNumber : \(self.MyNumber) : \(self.MyTeam):\(self.MyPosition)")
            self.setNumber()
        })


        
        
        
        
        
        
        
        
        
        self.myRootRef.childByAutoId().setValue([
           "longitude": "\(longitude)",
           "latitude" : "\(latitude)",
            "gps_info" : gps_info,
            ])
        

        self.myRootRef_uel_change = Firebase (url: ("https://onigokko.firebaseio.com/" + RoomID + "/url_change"))
        self.myRootRef_uel_change.observeEventType(.ChildAdded, withBlock: { snapshot in
            self.URL_move()
        })

        
    }
    
    func changeLabel(){
      
                self.everyLabel.hidden = true
                self.myButton.hidden = false
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        //gps_info作成
        var latitude_Int = (Int) (latitude * 10) % 10000
        var longitude_Int = (Int) (longitude * 10) % 10000
        //RoomID = "\(latitude_Int)" + "\(longitude_Int)"
        RoomID = "13258142"
        gps_info = "aaaaaaaa-aaaa-aaaa-aaaa-aaaa-" + RoomID
        // println(RoomID)
        lm.stopUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func onClickMyButton(sender: UIButton){
        self.myRootRef_uel_change.childByAutoId().setValue([
            "change": "yes",
            ])
        
    }
    
    func URL_move(){
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "firstViewController" ) as! UIViewController
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    

    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }

    func setNumber(){
        let numSize = (11/12 * 7/10 / 2) * w - 30
        var onePlaceView = UIImageView(image:UIImage(named: "\(AllNumber % 10)" + ".png"))
        var tenPlaceView = UIImageView(image:UIImage(named: "\(AllNumber / 10)" + ".png"))
        
        tenPlaceView.frame = CGRectMake(1/2 * w - 4 - numSize,  h/2 - numSize, numSize, numSize * 2)
        onePlaceView.frame = CGRectMake(1/2 * w + 4 ,  h/2 - numSize, numSize, numSize * 2)

        self.view.addSubview(onePlaceView)
        self.view.addSubview(tenPlaceView)
    }


}
