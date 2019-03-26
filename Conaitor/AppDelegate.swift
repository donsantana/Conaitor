
//
//  AppDelegate.swift
//  Xtaxi
//
//  Created by Done Santana on 14/10/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//

import UIKit
import SocketIO

struct myvariables {
    static var socket: SocketIOClient!
    static var cliente : CCliente!
    static var solicitudesproceso: Bool = false
    static var SMSProceso: Bool = false
    static  var taximetroActive: Bool = false
    static var solpendientes = [CSolicitud]()
    static var UrlSubirVoz: String!
    static var urlconductor: String = ""
    static var MsjConductor: String = ""
    static var MsjPendiente: CSMSVoz!
    static var SMSVoz = CSMSVoz()
    static var tarifas = [CTarifa]()
    static var grabando = false
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate{

    var window: UIWindow?
    
    var backgrounTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var myTimer: Timer?
    var BackgroundSeconds = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.isIdleTimerDisabled = true
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        //LEER SI EXISTE EL FICHERO DEL LOGIN
        
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
    func MensajeConductor() {
        myvariables.MsjConductor.removeAll()
        myvariables.socket.on("V"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            myvariables.urlconductor = temporal[1]
            let localNotification = UILocalNotification()
            localNotification.alertAction = "Mensaje del Conductor"
            localNotification.alertBody = "Mensaje del Conductor. Abra la aplicación para escucharlo."
            localNotification.fireDate = Date(timeIntervalSinceNow: 4)
            UIApplication.shared.scheduleLocalNotification(localNotification)
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
                self?.MensajeConductor()
            }else{
                myvariables.socket.emit("data", "#SocketClose," + myvariables.cliente.idCliente + ",# \n")
            }
            //self!.endBackgroundTask()
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
            if myvariables.urlconductor != ""{
                myvariables.SMSVoz.ReproducirMusica()
                myvariables.SMSVoz.ReproducirVozConductor(myvariables.urlconductor)
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
