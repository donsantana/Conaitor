//
//  CSocket.swift
//  Xtaxi
//
//  Created by Done Santana on 15/10/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//

import Foundation
import SocketIO

/*struct CSocket {
    //
    var serverUrl:String!
    
    init(serverUrl: String) {
        self.serverUrl = serverUrl
    }
    
    func connect(){
        //let socketIOManager = SocketManager(socketURL: URL(string: "http://www.xoait.com:5803")!, config: [.log(true), .forcePolling(true)])
        let socketIOManager = SocketManager(socketURL: URL(string: self.serverUrl)!, config: [.log(true), .forcePolling(true)])
        GlobalVariables.socket = socketIOManager.defaultSocket
        GlobalVariables.socket.connect()
    }
    
    func desconnect(){
        
    }
    
    //EVENTS
    func connectEvent(<#parameters#>) -> <#return type#> {
        GlobalVariables.socket.on("connect"){data, ack in
            var loginData = "Vacio"
            let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
            do {
                loginData = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String
            }catch {
            }
            if loginData != "Vacio"{
                self.Login(loginData: loginData)
            }else{
                self.AutenticandoView.isHidden = true
            }
            self.socketEventos()
        }
        <#function body#>
    }
    
    
}*/
