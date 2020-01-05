
//
//  AppDelegate.swift
//  Xtaxi
//
//  Created by Done Santana on 14/10/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//

import UIKit
import CoreLocation
import SocketIO
import AVFoundation
import GoogleMobileAds
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  
  var window: UIWindow?
  
  var backgrounTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
  var myTimer: Timer?
  var BackgroundSeconds = 0
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    application.isIdleTimerDisabled = true
    application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
    
    //VISUAL CUSTOMIZATION
    //Navigation Bar
    UINavigationBar.appearance().barTintColor = .init(Customization.primaryColor)
    
    // To change colour of tappable items.
    UINavigationBar.appearance().tintColor = Customization.textColor
    
    // To apply textAttributes to title i.e. colour, font etc.
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : Customization.textColor,
                                                        .font : UIFont.init(name: "Helvetica Neue", size: 20.0)!]
    
    // ToolBar
    UIToolbar.appearance().barTintColor = .init(Customization.primaryColor)
    
    UIToolbar.appearance().tintColor = Customization.textColor
    
    //TabBar
    UITabBar.appearance().barTintColor = .init(Customization.primaryColor)
    UITabBar.appearance().tintColor = Customization.textColor
    
    //UILabel.appearance().textColor = Customization.textColor
    //UIButton.appearance().setTitleColor(Customization.buttonsTitleColor,for: .normal)
    //UITextField.appearance().textColor = Customization.textColor
    //UITextView.appearance().textColor = Customization.textColor
    
    
    //GOOGLE ADS CODE
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    // Set the Google Place API's autocomplete UI control
    GMSPlacesClient.provideAPIKey("AIzaSyDOVTQUV2OeugiuBd3pAVGJbTx2aZ445Ws")
    
    
    return true
  }
  
  func IsMultitaskingSupported()->Bool{
    return UIDevice.current.isMultitaskingSupported
  }
  
  @objc func TimerMethod(sender: Timer){
    
    let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
    if backgroundTimeRemaining == DBL_MAX{
      print("Background Time Remaining = Undetermined")
    }else{
      BackgroundSeconds += 1
      print("Background Time Remaining = " + "\(BackgroundSeconds) Secunds")
      
    }
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    //self.MensajeConductor()
    myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerMethod), userInfo: nil, repeats: true)
    backgrounTaskIdentifier = application.beginBackgroundTask(withName: "task1", expirationHandler: {
      [weak self] in
      if (self?.BackgroundSeconds)! <= 1800 {
        self?.TimerMethod(sender: (self?.myTimer!)!)
      }else{
        GlobalVariables.socket.emit("data", "#SocketClose," + GlobalVariables.cliente.idCliente + ",# \n")
      }
    })
  }
  
  func endBackgroundTask(){
    if let timer = self.myTimer{
      timer.invalidate()
      self.myTimer = nil
      UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.backgrounTaskIdentifier.rawValue))
      self.backgrounTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    }
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    if backgrounTaskIdentifier != UIBackgroundTaskIdentifier.invalid{
      if GlobalVariables.urlconductor != ""{
        GlobalVariables.SMSProceso = true
        GlobalVariables.SMSVoz.ReproducirMusica()
        GlobalVariables.SMSVoz.ReproducirVozConductor(GlobalVariables.urlconductor)
      }
      if let timer = self.myTimer{
        timer.invalidate()
        self.myTimer = nil
        BackgroundSeconds = 0
        UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.backgrounTaskIdentifier.rawValue))
        self.backgrounTaskIdentifier = UIBackgroundTaskIdentifier.invalid
      }
    }
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    
  }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIBackgroundTaskIdentifier(_ input: Int) -> UIBackgroundTaskIdentifier {
  return UIBackgroundTaskIdentifier(rawValue: input)
}
