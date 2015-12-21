
//
//  ViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/01.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import MapKit
import Darwin
import AudioToolbox


//　グローバル変数てきなやつ　minor majorは消さない
var minor: CLBeaconMinorValue = 9
var major: CLBeaconMajorValue = 9

var accuracy_max=1.4
//var range_min=5.0
var range_max=7.0
var gps_info_address : String = "aaa"
var isObserving = false
var alert = UIAlertView()
var TN : String = ""
var TP : String = ""





class ViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBAction func TimeAlert(sender: AnyObject) {
        let myAlert: UIAlertController = UIAlertController(title: "Time limitとは？", message: "00:00になると全員ゲームオーバーのなってしまいます。\n頑張って捕まえましょう＾＾", preferredStyle: .Alert)
        let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
            print("Action OK!!")
        }
        myAlert.addAction(myOkAction)
        presentViewController(myAlert, animated: true, completion: nil)
        
        
    }
    @IBAction func indexChange(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            AbilityView.hidden = false
            MapView.hidden = true
            NewsView.hidden = true
            LogoPosition.hidden = false
            LogoTeam.hidden = false
            
        case 1:
            AbilityView.hidden = true
            MapView.hidden = false
            NewsView.hidden = true
            LogoPosition.hidden = true
            LogoTeam.hidden = true
        case 2:
            AbilityView.hidden = true
            MapView.hidden = true
            NewsView.hidden = false
            LogoPosition.hidden = true
            LogoTeam.hidden = true
            self.setRule()

        default:
            break;
        }
    }
    
    @IBAction func TestSkip(sender: AnyObject) {
        self.urlMoveToLoser()
    }
    @IBAction func ShowDeatails(sender: AnyObject) {
        
        alert.show()
    }
    @IBOutlet weak var LogoPosition: UIButton!
    @IBOutlet weak var scvBackGround: UIScrollView!
    @IBOutlet weak var NewsScrollView: UITextView!
    @IBOutlet weak var LabelRemainPeople: UILabel!
    @IBOutlet weak var LabelAllRemainPeople: UILabel!
    @IBOutlet weak var LabelTeamName: UILabel!
    @IBOutlet weak var LabelTeamPositio: UILabel!
    @IBOutlet weak var testlayout: NSLayoutConstraint!
    @IBOutlet weak var LogoTeam: UIImageView!
    @IBOutlet weak var NewsView: UIView!
    @IBOutlet weak var AbilityView: UIView!
    @IBOutlet weak var MapView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var textState: UITextView!
    
    @IBOutlet weak var time: UILabel!
    
    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
    var uuid: NSUUID! = NSUUID(UUIDString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
    var identifier: String! = "\(arc4random() % 10000 + 1)"
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()
    var region1 = CLBeaconRegion()
   // var minor: CLBeaconMinorValue = 9
   // var major: CLBeaconMajorValue = 9
    //var alive : Bool = true
   // var myMapLocationManager: CLLocationManager!
  
    
    
    var Team_Name: String = ""
    var Team_Position : String = ""
    var timer = NSTimer();
    var timer_gps = NSTimer();
    var timer_GameOver = NSTimer();
    var timer_setEvent = NSTimer();


    var targetURL = "https://goo.gl/tuQjPZ"

    var myImage = UIImage(named: "newLogo.png")
    var myImage_annotation = UIImage(named: "newLogo.png")


    var lm : CLLocationManager!
    var longitude : CLLocationDegrees!
    var latitude : CLLocationDegrees!
    
    
    var messageText : String = ""
    var counter : Int = 0

    //central
    var region = CLBeaconRegion()
    var locationManager = CLLocationManager()
    var metBeacons: [String] = []
    
    var team = "魏"
    var team_position = "平民"

    var myRootRef: Firebase!
    var myRootRef_theEnd: Firebase!
    var myRootRef_whoIsLoser: Firebase!
    var myRootRef_test: Firebase!
    var myRootRef_whereAreYou: Firebase!

    var num : Int = 0
    var MyNumber : Int = 0
    var flagSet : Int = 0
    var flagMapCenter : Int = 0
    var finishedGame : Int = 0
    
    var myPin  = [MKPointAnnotation]()
    var info  = [CustomPointAnnotation]()


    var RoomID :String = "test"

    //タイマー.
    var cnt : Int = 0
    var min : Int = 14
    var sec : Int = 59
    var timelimit : NSTimer!
    
    var theNumber : Int = 1

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        
        for i in 0..<20{
            myPin.append(MKPointAnnotation())
            info.append(CustomPointAnnotation())
        }
        
        
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        // Return時のイベントハンドル
        self.inputField.delegate = self
        
        timer_setEvent = NSTimer.scheduledTimerWithTimeInterval(3.0,target:self,selector:Selector("setEvent"),userInfo: nil, repeats: false);
        timer =  NSTimer.scheduledTimerWithTimeInterval(2.0 ,target:self,selector:Selector("sendBeaconReady"),userInfo: nil, repeats: false);
        timer_gps = NSTimer.scheduledTimerWithTimeInterval(4.0,target:self,selector:Selector("sendAndGetInfo"),userInfo: nil, repeats: true);
        timer_GameOver = NSTimer.scheduledTimerWithTimeInterval(900.0,target:self,selector:Selector("urlMoveToLoser"),userInfo: nil, repeats: false);
        timelimit = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

        
        MapView.layer.cornerRadius = 20
        MapView.layer.masksToBounds = true
        


        AbilityView.layer.cornerRadius = 40
        AbilityView.layer.masksToBounds = true
        
        NewsScrollView.layer.cornerRadius = 20
        NewsView.layer.masksToBounds = true
        NewsScrollView.layer.masksToBounds = true
        NewsScrollView.layer.cornerRadius = 20.0
        
        textState.layer.masksToBounds = true
        textState.layer.cornerRadius = 20.0
        textState.dataDetectorTypes = UIDataDetectorTypes.All
        textState.scrollEnabled = true
        textState.scrollsToTop = false

        
       //self.myMapView.delegate = self
        

    }
    
    func setRule(){
        var ruleImage = UIImage(named:"rule.png")
        var ruleImageView = UIImageView(image:ruleImage)
        ruleImageView.frame = CGRectMake(1/2 * w - 1/3 * w , 0 , 2/3 * w , 1/2 * h)
        self.NewsView.addSubview(ruleImageView)
        self.textState.text = "\nジャンケンのような相関関係があります。\n特定のチームから逃げて特定のチームを追いかける、またどこかの王様が捕まるとゲーム終了です。\n\n" + self.textState.text
    }
    
    
      //central
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        for beacon in beacons {
            var currentBeacon = beacon as! CLBeacon
            var minor_current = currentBeacon.minor.stringValue
            var major_current = currentBeacon.major.stringValue
            var beaconID = "\(minor)_\(major)"
            var txtActiveField = UITextField()
            
            
            if contains(metBeacons, beaconID) {
                //Already met
            } else {
                var consoleText = "Met a new iBeacon with ID \(beaconID)"
                sendLocalNotificationWithMessage(consoleText)
                // println(consoleText)
                metBeacons.append(beaconID)
            }
            
         
            var accuracy = currentBeacon.accuracy
            
            var proximity: String!
            switch currentBeacon.proximity {
            case CLProximity.Immediate:
                proximity = "Very close"
                
            case CLProximity.Near:
                proximity = "Near"
                
            case CLProximity.Far:
                proximity = "Far"
                
            default:
                proximity = "No proximity data"
            }
            
            
            var rssi = currentBeacon.rssi
            
          
            
            var flagWrite : Int = 0
        
            self.counter++
            println("myname:\(team), myPosition:\(Team_Position), major:\(major), minor:\(minor), major_central:\(major_current), minor_central:\(minor_current),\(self.counter)回")
            
            
            var textnow : String = ReturnWinOrLose(major, currentMajor: major_current)
            if(self.counter < 3){
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                switch textnow {
                    
                case "lose":
                    notificationOnTextState(textnow)
                    if("\(minor_current)" == 2){
                        
                        if(accuracy < accuracy_max * 2){
                            deleteFromMap()
                            sendToSurver(team, Position: Team_Position)
                            locationManager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
                            locationManager.stopRangingBeaconsInRegion(region1 as CLBeaconRegion)
                            lm.stopUpdatingLocation()
                            urlMoveToLoser()
                        }
                        
                    }else{
                        
                        if(accuracy < accuracy_max ){
                            deleteFromMap()
                            sendToSurver(team, Position: Team_Position)
                            locationManager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
                            locationManager.stopRangingBeaconsInRegion(region1 as CLBeaconRegion)
                            lm.stopUpdatingLocation()
                            urlMoveToLoser()
                        }
                        
                    }
                    break
                    
                case "win":
                    notificationOnTextState(textnow)
                    
                case "same":
                    break
                default :
                    break
                    
                }
            }
            }

            
       
    }
    
    
    
   

    func urlMoveToLoser(){
        //timerを破棄する.
        timer.invalidate()
        timer_gps.invalidate()
        timer_GameOver.invalidate()
        timer_setEvent.invalidate()
        timelimit.invalidate()
        locationManager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        locationManager.stopRangingBeaconsInRegion(region1 as CLBeaconRegion)
        lm.stopUpdatingLocation()
        if(self.finishedGame == 0){
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.finishedGame = self.finishedGame + 1
        }
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "loserView" ) as! UIViewController
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    
    func urlMoveToWiner(){
        
        //timerを破棄する.
        timer.invalidate()
        timer_gps.invalidate()
        timer_GameOver.invalidate()
        timer_setEvent.invalidate()
        timelimit.invalidate()
        locationManager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        locationManager.stopRangingBeaconsInRegion(region1 as CLBeaconRegion)
        lm.stopUpdatingLocation()
        if(self.finishedGame == 0){
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.finishedGame = self.finishedGame + 1
        }
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "winerView" ) as! UIViewController
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    
    
    func ReturnWinOrLose(myMajor:CLBeaconMinorValue!, currentMajor: String!) -> String!{
        var text : String! = ""
        
        switch "\(myMajor)" {
        case "0":
            switch currentMajor {
            case "0":
                text = "same"
            case "1":
                text = "win"
            case "2":
                text = "lose"
            default :
                text = "error"
                break
            }

        case "1":
            switch currentMajor {
            case "0":
                text = "lose"
            case "1":
                text = "same"
            case "2":
                text = "win"
            default :
                text = "error"
                break
            }
        case "2":
            switch currentMajor {
            case "0":
                text = "win"
            case "1":
                text = "lose"
            case "2":
                text = "same"
            default :
                text = "error"
                break
            }
        default :
            break
        }
        println("called ReturnWinOrLose method: return(\(text))")
        return text
    }
    
    //引数は勝っているか負けているかで
    func notificationOnTextState(winOrLose : String!){
       // AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        switch winOrLose {
        case "win":
            textState.text = ("近くに敵がいます。捕まえましょう。")
        case "lose":
            textState.text = ("逃げて！　周囲に敵がいます!")
        default:
            textState.text = ("error")
        }
        println("called notificationOnTextState method")

    }
    //mapから消える
    func deleteFromMap(){
        //むずいからあとから実装
         println("called deleteFromMap method")
    }
    
    //send to surver
    func sendToSurver(Name : String!,Position : String!){
        
        self.myRootRef_theEnd.childByAutoId().setValue([
            "teamName": Name,
            "teamPosition": Position ,
            ])
        println("called sendToSurver method")

    }

  
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        // println("ViewController :L240")
        return anView
    }
    
    
    func makePin(theLatitude : String, theLongitude : String, team : String, position : String){
      
        self.theNumber = teamAndPositionToNum(team, position : position)
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(atof(theLatitude),atof(theLongitude))
        myPin[self.theNumber].coordinate = centerCoordinate
        info[self.theNumber].coordinate = centerCoordinate
        setImageOnMap()
        //myPin[theNumber].title = team
        //myPin[theNumber].subtitle = position
      // println("\(MyNumber)ViewController :L230 :myPin :\(theNumber),theLatitude : \(theLatitude),theLongitude : \(theLongitude), team : \(team), position : \(position)")
        //myMapView.delegate = self
        
        if(3 < self.MyNumber && self.MyNumber < 7){
            myPin[theNumber].title = team
            myPin[theNumber].subtitle = position
        }
        myMapView.addAnnotation(info[self.theNumber])
    }
    
    
    
    func setImageOnMap(){
        if(3 < self.MyNumber && self.MyNumber < 7){
            
            switch self.theNumber {
            case 0 :
                info[self.theNumber].imageName = "mini_Gi-King.png"
            case 1 :
                info[self.theNumber].imageName = "mini_Go-King.png"
            case 2 :
                info[self.theNumber].imageName = "mini_Shoku-King.png"
            case 3 :
                info[self.theNumber].imageName = "mini_Gi-Strategist.png"
            case 4 :
                info[self.theNumber].imageName = "mini_Go-Strategist.png"
            case 5 :
                info[self.theNumber].imageName = "mini_Shoku-Strategist.png"
            case 6 :
                info[self.theNumber].imageName = "mini_Gi-Night.png"
            case 7 :
                info[self.theNumber].imageName = "mini_Go-Night.png"
            case 8:
                info[self.theNumber].imageName = "mini_Shoku-Night.png"
            case 9 :
                info[self.theNumber].imageName = "mini_Gi-Citizen.png"
            case 10 :
                info[self.theNumber].imageName = "mini_Go-Citizen.png"
            case 11 :
                info[self.theNumber].imageName = "mini_Shoku-Citizen.png"
            case 12 :
                info[self.theNumber].imageName = "mini_Gi-Citizen.png"
            case 13 :
                info[self.theNumber].imageName = "mini_Go-Citizen.png"
            case 14 :
                info[self.theNumber].imageName = "mini_Shoku-Citizen.png"
            case 15 :
                info[self.theNumber].imageName = "mini_Gi-Citizen.png"
            case 16 :
                info[self.theNumber].imageName = "mini_Go-Citizen.png"
            case 17 :
                info[self.theNumber].imageName = "mini_Shoku-Citizen.png"
            case 18 :
                info[self.theNumber].imageName = "mini_Gi-Citizen.png"
            case 19 :
                info[self.theNumber].imageName = "mini_Go-Citizen.png"
            case 20 :
                info[self.theNumber].imageName = "mini_Shoku-Citizen.png"
            default :
                info[self.theNumber].imageName = "mini_Gi-Citizen.png"
            }
        }else{
            if((self.theNumber % 3) == 0){
                info[self.theNumber].imageName = "Gi.png"
            }else if((self.theNumber % 3) == 1){
                info[self.theNumber].imageName = "Go.png"
            }else if ((self.theNumber % 3) == 2){
                info[self.theNumber].imageName = "Shoku.png"
            }
        }
    }
    


    func update() {
        self.cnt++
        var minRemain : Int = self.min - (self.cnt / 60)
        var secRemain : Int = self.sec - (self.cnt % 60)
        if(minRemain < 10){
            if(secRemain < 10){
                self.time.text = "0\(minRemain):0\(secRemain)"
            }else{
                self.time.text = "0\(minRemain):\(secRemain)"
            }
        }else{
            if(secRemain < 10){
                self.time.text = "\(minRemain):0\(secRemain)"
            }else{
                self.time.text = "\(minRemain):\(secRemain)"
            }
        }
        
        
    }

    func setEvent(){
         alert.addButtonWithTitle("OK")
        switch Team_Position{
        case "王":
            
            alert.title = "貴方の役職は王"
            alert.message = "捕まるとチームが負けます。"
            break
            
        case "武人":
            alert.title = "貴方の役職は武人"
            alert.message = "人より相手を捕まえれる範囲が広いです"
            break
            
            
        case "軍師":
            alert.title = "貴方の役職は軍師"
            alert.message = "全員の位置と詳細がmapで見れます。\n味方をサポートしましょう。"
            break
            
        default:
            alert.title = "貴方の役職は平民"
            alert.message = "平民です。能力は特にありません。"
            break
            
        }
        

        
        
        // Firebaseへ接続
        self.myRootRef = Firebase(url: ("https://onigokko.firebaseio.com/" + RoomID + "/message"))
        self.myRootRef_theEnd = Firebase(url: ("https://onigokko.firebaseio.com/" + RoomID + "/deadList"))
        self.myRootRef_whoIsLoser = Firebase (url: ("https://onigokko.firebaseio.com/" + RoomID + "/whoIsLoser"))
        self.myRootRef_whereAreYou = Firebase (url:  ("https://onigokko.firebaseio.com/" + RoomID + "/whereAreYou") )
        
        
        
        // Child追加時のイベントハンドラ
        self.myRootRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let teamName = snapshot.value.objectForKey("teamName") as? String {
                if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                    if let message = snapshot.value.objectForKey("message") as? String {
                        if( self.Team_Name == "\(teamName)"){
                            //self.messageText =  "\(teamPosition) -> \( message )\n\(self.messageText)"
                            self.textState.text = "\(teamPosition) -> \( message )\n\(self.textState.text)\n"
                            self.textState.selectedRange = NSMakeRange(count(self.textState.text), 1);

                        }
                    }
                }
            }
        })
        
        
        // Child追加時のイベントハンドラ_theEnd_
        self.myRootRef_theEnd.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let teamName = snapshot.value.objectForKey("teamName") as? String {
                if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                    var loserTeam : String = "\(teamName)"
                    var winner :  String = ""
                    
                    if( "\(teamPosition)" == "王"){
                        if(self.Team_Name == self.winnerTeam(teamName)){
                            self.urlMoveToWiner()
                        }else{
                            self.locationManager.stopRangingBeaconsInRegion(self.region as CLBeaconRegion)
                            self.locationManager.stopRangingBeaconsInRegion(self.region1 as CLBeaconRegion)
                            self.lm.stopUpdatingLocation()
                            self.urlMoveToLoser()
                        }
                        
                    }else{
                        
                         self.textState.text = "\(teamName):\(teamPosition)が敵国の捕虜になりました。\n " + self.textState.text
                         if(self.Team_Name == "\(teamName)"){
                            self.LabelRemainPeople.text = "\(self.LabelRemainPeople.text!.toInt()! - 1)"
                         }
                         self.LabelAllRemainPeople.text = "\(self.LabelAllRemainPeople.text!.toInt()! - 1)"
                        
                    }
                   
                }
            }
        })
        // Child追加時のイベントハンドラ_whoIsLoser_
        self.myRootRef_whoIsLoser.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let LoserTeamName = snapshot.value.objectForKey("LoserTeamName") as? String{
                if (LoserTeamName == "\(major)"){
                    self.urlMoveToLoser()
                }else{
                    self.urlMoveToWiner()
                }
            }
        })
        
        
        
        // 接続直後に呼び出されるイベントハンドラ
        self.myRootRef.observeEventType(.Value, withBlock: { snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            if let teamName = snapshot.value.objectForKey("teamName") as? String {
                if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                    if let message = snapshot.value.objectForKey("message") as? String {
                        if( self.Team_Name == "\(teamName)"){
                            self.messageText =  "\(teamPosition) -> \( message )\n\(self.messageText)"
                            self.textState.text = "\(teamPosition) -> \( message )\n\(self.messageText)\n"
                            self.textState.selectedRange = NSMakeRange(count(self.textState.text), 1);


                        }
                    }
                }
            }
        })
        // 接続直後に呼び出されるイベントハンドラ_theEnd
        self.myRootRef_theEnd.observeEventType(.Value, withBlock: { snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            if let teamName = snapshot.value.objectForKey("teamName") as? String {
                if let teamPosition = snapshot.value.objectForKey("teamPosition") as? String {
                    self.NewsScrollView.text = "\(self.NewsScrollView.text)\n\(teamName):\(teamPosition)が敵国の捕虜になりました。 "
                    if(self.Team_Name == "\(teamName)"){
                        self.LabelRemainPeople.text = "\(self.LabelRemainPeople.text!.toInt()! - 1)"
                    }
                    self.LabelAllRemainPeople.text = "\(self.LabelAllRemainPeople.text!.toInt()! - 1)"
                }
            }
            
        })
        
        self.myRootRef_whoIsLoser.observeEventType(.Value, withBlock: { snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            if let LoserTeamName = snapshot.value.objectForKey("LoserTeamName") as? String{
                if (LoserTeamName == "\(major)"){
                    self.urlMoveToLoser()
                }else{
                    self.urlMoveToWiner()
                }
            }
        })
        
        
    }
    
    
    func winnerTeam(loserTeam: String) -> String{
        var winnerTeam : String = "test"
        
        switch loserTeam{
            case "魏":
            winnerTeam = "呉"
            case "呉":
            winnerTeam = "蜀"
            case "蜀":
            winnerTeam = "魏"
            default:
            winnerTeam = "erroor"
            break
        }
      
        println("called winnerTeam method: return(\(winnerTeam))")
        return winnerTeam
    }
    
    func sendAndGetInfo(){
        
        //delete whereAreYou
        self.myRootRef_test = Firebase(url: ("https://onigokko.firebaseio.com/" + RoomID + "/url_change"))
        self.myRootRef_test.setValue(nil)
        
        switch "\(major)" {
        case "0":
            TN = "魏"
            switch "\(minor)" {
                case "0":
                     TP  = "王"
                case "1":
                     TP  = "軍師"
                case "2":
                     TP  = "武人"
                default:
                     TP  = "平民"
            }
        case "1":
            TN = "呉"
            switch "\(minor)" {
            case "0":
                TP  = "王"
            case "1":
                TP  = "軍師"
            case "2":
                TP  = "武人"
            default:
                TP  = "平民"
            }

        case "2":
            TN = "蜀"
            switch "\(minor)" {
            case "0":
                TP  = "王"
            case "1":
                TP  = "軍師"
            case "2":
                TP  = "武人"
            default:
                TP  = "平民"
            }
        default:
            TN = "エラー"
            switch "\(minor)" {
            case "0":
                TP  = "王"
            case "1":
                TP  = "軍師"
            case "2":
                TP  = "武人"
            default:
                TP  = "平民"
            }
            break
        }
        let theMyNumber : Int = "\(major)".toInt()! + "\(minor)".toInt()! * 3
        let allMenber : Int = "\(LabelAllRemainPeople.text!)".toInt()!
    
        //let TeamName = self.Team_Name
        //let TeamPosition = self.Team_Position
        
        //myRootRef_whereAreYou.setValue("Do you have data? You'll love Firebase.")
        
        //if (self.flagSet == 0){
            
            //myRootRef_whereAreYou = Firebase (url:  "https://onigokko.firebaseio.com/gps/whereAreYou/" + "\(gps_info_address)" + "\(major)" + "\(minor)")
            //let theMyNumber : Int = MyNumber
            myRootRef_whereAreYou.childByAppendingPath("\(theMyNumber)").setValue([
                "longitude" : "\(self.longitude)",
                "latitude" : "\(self.latitude)",
                "teamName" : "\(TN)",
                "teamPosition" : "\(TP)",
                // "MyNumber" : theMyNumber
                ])
            
            myRootRef_whereAreYou.childByAppendingPath("\(theMyNumber)").observeEventType(.Value, withBlock: { snapshot in
                if let isNull = snapshot.value as? NSNull {
                    return
                }
                let name = snapshot.value.objectForKey("teamName") as? String
                let posi = snapshot.value.objectForKey("teamPosition") as? String
                let lati = snapshot.value.objectForKey("latitude") as? String
                let long = snapshot.value.objectForKey("longitude") as? String
                //let num = snapshot.value.objectForKey("MyNumber") as? Int
                //self.textState.text = self.textState.text + name! + ("->") + posi! + lati! + "  " + long!
                self.makePin(lati!, theLongitude: long!, team: name!, position: posi!)
            })
            
            
            for i in 0 ... ("\(LabelAllRemainPeople.text!)".toInt()! - 1)  {
            
            myRootRef_whereAreYou.childByAppendingPath("\(i)").observeEventType(.Value, withBlock: { snapshot in
                if let isNull = snapshot.value as? NSNull {
                    return
                }
                let name = snapshot.value.objectForKey("teamName") as? String
                let posi = snapshot.value.objectForKey("teamPosition") as? String
                let lati = snapshot.value.objectForKey("latitude") as? String
                let long = snapshot.value.objectForKey("longitude") as? String
                //let num = snapshot.value.objectForKey("MyNumber") as? Int
               // self.textState.text = self.textState.text + name! + ("->") + posi! + lati! + "  " + long!
                self.makePin(lati!, theLongitude: long!, team: name!, position: posi!)
                
            })
                
            }
        
          
            //self.flagSet = 1
        //}
        
        /*
        myRootRef_whereAreYou.childByAppendingPath("\(gps_info_address)" ).childByAppendingPath("\(theMyNumber)").setValue([
            "longitude" : "\(self.longitude)",
            "latitude" : "\(self.latitude)",
            "teamName" : "\(TN)",
            "teamPosition" : "\(TP)",
            ]
*/

    }
    

    
    
    func teamAndPositionToNum(team : String, position : String)->Int{
        var theNumber : Int = 0
        switch team{
        case "魏":
        
        switch position{
            case "王": theNumber = 0
            case "軍師": theNumber = 3
            case "武人": theNumber = 6
            case "平民１": theNumber = 9
            case "平民2" : theNumber = 12
        default : break
            }
            
        case "呉":
            switch position{
            case "王": theNumber = 1
            case "軍師": theNumber = 4
            case "武人": theNumber = 7
            case "平民１": theNumber = 10
            case "平民2" : theNumber = 13
            default : break
            }
            
        case "蜀":
            switch position{
            case "王": theNumber = 2
            case "軍師": theNumber = 5
            case "武人": theNumber = 8
            case "平民１": theNumber = 11
            case "平民2" : theNumber = 14
            default : break
            }
            
        default: break
        }
        return theNumber
    }
    

    
    
    func sendBeaconReady(){
        //println("view: sendBeaconReady: uuid : " + "\(uuid)")
        peripheralManager.delegate = self
        //central
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        region = CLBeaconRegion(proximityUUID: uuid, identifier: "\(arc4random() % 10000 + 1)")!
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
        // minor = CLBeaconMinorValue(minor)
        // major = CLBeaconMajorValue(major)
        Team_Name = LabelTeamName.text!
        Team_Position = LabelTeamPositio.text!
        region1 = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: "\(arc4random() % 10000 + 1)" )
        advertisedData = region1.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        
        //var myUrlStr:String = "https://onigokko.firebaseio.com/gps/whereAreYou/" + "\(gps_info_address)" + "\(major)" + "\(minor)"
        /*
        
        self.myRootRef_whereAreYou = Firebase (url:  "https://onigokko.firebaseio.com/gps/whereAreYou/" + "\(gps_info_address)" + "\(major)" + "\(minor)")
        
        // Child追加時のイベントハンドラ_whoIsLoser_
        self.myRootRef_whereAreYou.observeEventType(.ChildAdded, withBlock: { snapshot in
            let name = snapshot.value.objectForKey("teamName") as? String
            let posi = snapshot.value.objectForKey("teamPosition") as? String
            self.textState.text = "\(name)" + ("->") + "\(posi)"
        })
        self.myRootRef_whereAreYou.observeEventType(.Value, withBlock: { snapshot in
             let name = snapshot.value.objectForKey("teamName") as? String
            let posi = snapshot.value.objectForKey("teamPosition") as? String
            self.textState.text = "\(name)" + ("->") + "\(posi)"
        })
*/
       
        /*
        self.myRootRef_whereAreYou.observeEventType(.ChildAdded,withBlock:{ snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            if let a111 = snapshot.value.objectForKey("latitude") as? String{
                if let a222 = snapshot.value.objectForKey("longitude") as? String{
                    if let a333 = snapshot.value.objectForKey("teamName") as? String{
                        if let a444 = snapshot.value.objectForKey("teamPosition") as? String{
                            self.textState.text = "\(self.textState.text)\n\(a333) -> \(a444)"
                        }
                    }
                }
            }
        })
        */
    }
    
 

    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var myLocations: NSArray = locations as NSArray
        var myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        var myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        //print("\(myLocations)")
        
        
        latitude = manager.location.coordinate.latitude
        longitude = manager.location.coordinate.longitude
        
        //self.LabelTeamName.text = "\(longitude)"
        //self.LabelTeamPositio.text = "\(latitude)"
        
        let myLatDist : CLLocationDistance = 80
        let myLonDist : CLLocationDistance = 80
        
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        if(self.flagMapCenter == 0){
            myMapView.setRegion(myRegion, animated: true)
            self.flagMapCenter = 1
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        //println("regionDidChangeAnimated")
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .AuthorizedWhenInUse: break
            //println("AuthorizedWhenInUse")
            //    case .Authorized:
            //        println("Authorized")
        case .Denied:break
           // println("Denied")
        case .Restricted:break
           // println("Restricted")
        case .NotDetermined:break
            //println("NotDetermined")
        default:break
           // println("etc.")
        }
    }
    
 
    
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        case CBPeripheralManagerState.PoweredOff:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        case CBPeripheralManagerState.Resetting:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        case CBPeripheralManagerState.Unauthorized:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        case CBPeripheralManagerState.Unsupported:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        default:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
        }
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // キーボードを隠す
        textField.resignFirstResponder()
        // 入力内容を登録
        self.myRootRef.childByAutoId().setValue([
            "teamName": LabelTeamName.text,
            "teamPosition": LabelTeamPositio.text,
            "message":textField.text
            ])
        // TextFieldの入力内容をクリア
        textField.text = ""
        
        self.view.endEditing(true)
        return true
    }

    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        sendLocalNotificationWithMessage("Beacon is in range")
        let consoleText = "\n\(getCurrentDate()) <C>: iBeacon is in range"
        //println(consoleText)
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.stopUpdatingLocation()
        sendLocalNotificationWithMessage("Beacon is out of range")
        let consoleText = "\n\(getCurrentDate()) <C>: iBeacon is out of range"
       // println(consoleText)
        self.textState.text = ("逃げれました。")
    }
    func getCurrentDate() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        LabelTeamName.text =  appDelegate.ViewVal
        Team_Name = appDelegate.ViewVal
        LabelTeamPositio.text =  appDelegate.ViewVal1
        Team_Position =  appDelegate.ViewVal1
        LabelRemainPeople.text = "\(appDelegate.ViewVal3)"
        LabelAllRemainPeople.text = "\(appDelegate.ViewVal2)"
        gps_info_address = "\(appDelegate.ViewVal4)"
        MyNumber = appDelegate.ViewVal5
        RoomID = appDelegate.ViewVal6

     
        /*
        switch Team_Position{
        case "王":
            alert.title = "貴方の役職は王"
            alert.message = "捕まるとチームが負けます。"
            alert.addButtonWithTitle("OK")

        case "武人":
            alert.title = "貴方の役職は武人"
            alert.message = "人より相手を捕まえれる範囲が広いです"
            alert.addButtonWithTitle("OK")

            
        case "軍師":
            alert.title = "貴方の役職は軍師"
            alert.message = "全員の位置と詳細がmapで見れます。\n味方をサポートしましょう。"
            alert.addButtonWithTitle("OK")

        default:
            alert.title = "貴方の役職は平民"
            alert.message = "平民です。能力は特にありません。"
            alert.addButtonWithTitle("OK")

        }
        */
        
        
        
        func ChangeImage(){
            
            switch appDelegate.ViewVal {
            case "魏":
                major = 0
                switch appDelegate.ViewVal1{
                case "王":
                    minor = 0
                    myImage = UIImage(named: "Gi-King.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                case "武人":
                    minor = 2
                    myImage = UIImage(named: "Gi-Night.png")
                    LogoPosition.setImage(myImage, forState: .Normal)

                case "軍師":
                    minor = 1
                    myImage = UIImage(named: "Gi-Strategist.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                default:
                    minor = 3
                    myImage = UIImage(named: "Gi-Citizen.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                }
            case "呉":
                major = 1
                switch appDelegate.ViewVal1 {
                case "王":
                    minor = 0
                    myImage = UIImage(named: "Go-King.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                case "武人":
                    minor = 2
                    let myImage = UIImage(named: "Go-Night.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                    
                case "軍師":
                    minor = 1
                    myImage = UIImage(named: "Go-Strategist.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                default:
                    minor = 3
                    myImage = UIImage(named: "Go-Citizen.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                }
            case "蜀":
                major = 2
                switch appDelegate.ViewVal1 {
                case "王":
                    minor = 0
                    myImage = UIImage(named: "Shoku-King.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                case "武人":
                    minor = 2
                    myImage = UIImage(named: "Shoku-Night.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                    
                case "軍師":
                    minor = 1
                    myImage = UIImage(named: "Shoku-Strategist.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                default:
                    minor = 3
                    let myImage = UIImage(named: "Shoku-Citizen.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                }
            default:
                major = 7
                switch appDelegate.ViewVal1 {
                case "王":
                    minor = 0
                    myImage = UIImage(named: "Gi-King.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                case "武人":
                    minor = 2
                    myImage = UIImage(named: "Gi-Night.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                    
                case "軍師":
                    minor = 1
                    myImage = UIImage(named: "Gi-Strategist.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                default:
                    minor = 3
                    myImage = UIImage(named: "Gi-Citizen.png")
                    LogoPosition.setImage(myImage, forState: .Normal)
                }
                break
            }
        }
        ChangeImage()
        
        let myAlert: UIAlertController = UIAlertController(title: "！！確認してください！！", message: "このゲームはBluetoothを使用します。\n必ずBluetoothをonにしてください。", preferredStyle: .Alert)
        let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
            // print("Action OK!!")
        }
        myAlert.addAction(myOkAction)
        presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}


