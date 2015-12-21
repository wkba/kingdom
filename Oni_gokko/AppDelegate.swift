//
//  AppDelegate.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/01.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    private var team_Name: String = ""
    var ViewVal: String {
        get {
            return team_Name
        }
        set {
            team_Name = newValue
        }
    }
    private var team_Position: String = ""
    var ViewVal1: String {
        get {
            return team_Position
        }
        set {
            team_Position = newValue
        }
    }
    private var all_member: Int = 0
    var ViewVal2: Int {
        get {
            return all_member
        }
        set {
            all_member = newValue
        }
    }
    
    private var team_member: Int = 0
    var ViewVal3: Int {
        get {
            return team_member
        }
        set {
            team_member = newValue
        }
    }
    private var info_gps: String = ""
    var ViewVal4: String {
        get {
            return info_gps
        }
        set {
            info_gps = newValue
        }
    }
    
    private var MyNumber: Int = 0
    var ViewVal5: Int {
        get {
            return MyNumber
        }
        set {
            MyNumber = newValue
        }
    }
    
    private var RoomID: String = ""
    var ViewVal6: String {
        get {
            return RoomID
        }
        set {
            RoomID = newValue
        }
    }
    
    
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

