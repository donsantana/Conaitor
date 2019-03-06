//
//  UploadController.swift
//  XTaxi
//
//  Created by Done Santana on 19/7/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation

public class UploadController {
    public typealias CompletionHandler = (obj:AnyObject?, success: Bool?) -> Void
    
    public func UploadNative(name: String, destinourl: String, _ aHandler: CompletionHandler?) -> Void {
        let url = NSURL(string: destinourl)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        
        let filePath = NSHomeDirectory() + "/Library/Caches/" + name + ".m4a"
        let soundURL = NSURL.fileURLWithPath(filePath)
        // Set Content-Type in HTTP header.
        let boundaryConstant = "Boundary-7MA4YWxkTLLu0UIW"; // This should be auto-generated.
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
        let fileName = name
        let mimeType = "m4a"
        let fieldName = "audio"
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Set data
       // var error: NSError?
        var dataString = "--\(boundaryConstant)\r\n"
        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        dataString += "Content-Type: \(mimeType)\r\n\r\n"
        do{
            let file = NSHomeDirectory() + "/Library/Caches/" + name + ".m4a"
            let soundURL = NSURL.fileURLWithPath(file)
            dataString += try String(contentsOfURL: soundURL, encoding: NSUTF8StringEncoding)
        }
        catch {
            exit(0)
        }
        dataString += "\r\n"
        dataString += "--\(boundaryConstant)--\r\n"
        
        print(dataString) // This would allow you to see what the dataString looks like.
        
        // Set the HTTPBody we'd like to submit
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        // Make an asynchronous call so as not to hold up other processes.
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, dataObject, error) in
            if let _ = error {
                aHandler?(obj: error, success: false)
            } else {
                aHandler?(obj: dataObject, success: true)
            }
        })
    }
    
}