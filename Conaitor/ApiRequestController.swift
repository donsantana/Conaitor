//
//  ApiRequestController.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation

protocol ApiRequestDelegate: class {
    func apiRequest(_ controller: ApiRequestController, getLoginToken token: String)
    func apiRequest(_ controller: ApiRequestController, getServerData serverData: String)
}

final class ApiRequestController {
    
    weak var delegate: ApiRequestDelegate?
    
    func loginToAPIService(){
        var token = ""
        let params = ["email":GlobalConstants.apiUser, "password":GlobalConstants.apiPassword] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: GlobalConstants.apiLoginUrl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if error == nil{
                print(response!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.delegate?.apiRequest(self, getLoginToken: json["token"] as! String)//self.getServerConnectionData(token: json["token"] as! String)
                } catch {
                    print("error")
                }
            }else{
                //print("error \(error)")
            }
        })
        
        task.resume()
    }
    
    func getServerConnectionData(token: String){
        let header = ["Authorization":"Bearer \(token)"] as Dictionary<String, String>
        var request = URLRequest(url: URL(string: GlobalConstants.apiServerPortUrl)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if error == nil{
                //print("respuesta \(response["cliente"])")
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.delegate?.apiRequest(self, getServerData: "\(json["cliente"]!["ip"] as! String):\(json["cliente"]!["p"] as! String)")
                    //Customization.serverData = "\(json["cliente"]!["ip"] as! String):\(json["cliente"]!["p"] as! String)"
                } catch {
                    print("error URL")
                }
            }else{
                //print("error \(error)")
            }
        })
        task.resume()
    }
}

