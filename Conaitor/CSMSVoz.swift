//
//  CSMSVoz.swift
//  Xtaxi
//
//  Created by usuario on 5/5/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class CSMSVoz: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, AVAudioPlayerDelegate {
    
    var myPlayer = AVPlayer()
    var myMusica = AVAudioPlayer()
    var myAudioPlayer = AVAudioPlayer()
    //var playSession = AVAudioSession()
    var vozConductor = AVAudioPlayer()
    var recordingSession = AVAudioSession()
    var audioRecorder: AVAudioRecorder!
    var urlSubir: String!
    var responseData = NSMutableData()
    var data: Data!
    var reproduciendo = false
    //var AudioSetCategory: AVAudioSetCategory = AVAudioSetCategory()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let myFilePathString = Bundle.main.path(forResource: "beep", ofType: "wav")
        
        if let myFilePathString = myFilePathString
        {
            let myFilePathURL = URL(fileURLWithPath: myFilePathString)
            
            do{
                try myMusica = AVAudioPlayer(contentsOf: myFilePathURL)
                myMusica.prepareToPlay()
                myMusica.volume = 1
            }catch
            {
                print("error")
            }
        }
        
        //INICIALIAR GRABACIÓN
        if (recordingSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    //set category and activate recorder session
                    //self.AudioSetCategory.setAudio(self.recordingSession)
                    try! self.recordingSession.setActive(true)
                    /*if #available(iOS 10.0, *) {
                     try! self.recordingSession.setCategory(.playAndRecord, mode: .default)
                     try! self.recordingSession.setActive(true)
                     } else {
                     // Fallback on earlier versions
                     }*/
                    
                    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(8000.0) as Float),
                                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                                          AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.low.rawValue) as Int32)]
                    
                    let audioSession = AVAudioSession.sharedInstance()
                    do {
                        if #available(iOS 10.0, *) {
                            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                        } else {
                            audioSession.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord)
                            try audioSession.overrideOutputAudioPort(.speaker)
                        }
                        try self.audioRecorder = AVAudioRecorder(url: self.directoryURL()!,settings: recordSettings)
                        self.audioRecorder.prepareToRecord()
                    } catch {
                        
                    }
                    
                } else{
                    print("not granted")
                }
            })
        }
    }
    
    /*func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
     if !flag {
     finishRecording(success: false)
     }
     }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // get the path of our file
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        //var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        //let urls = NSHomeDirectory() + "/Library/Caches/audio.m4a"
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("audio.m4a")
        //let soundURL = NSURL.fileURLWithPath(urls as String)
        return soundURL
    }
    
    //para reproducir audio de internet
    func PlayForInternet(_ url: String){
        let url = url
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        myPlayer = AVPlayer(playerItem:playerItem)
        myPlayer.rate = 1.0
        myPlayer.play()
    }
    
    func GrabarMensaje(){
        if !self.reproduciendo{
            if !audioRecorder.isRecording{
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(true)
                    audioRecorder.record()
                } catch {
                }
            }
        }
    }
    
    func TerminarMensaje(_ name: String){
        if !self.reproduciendo{
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
                let filePath = NSHomeDirectory() + "/Library/Caches/Audio" + name
                let audio = try? Data(contentsOf: directoryURL()!)
                try? audio?.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
                
            } catch {
            }
        }
    }
    
    func ReproducirMensaje(){
        if (!audioRecorder.isRecording){
            do {
                try myAudioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
    
                myAudioPlayer.prepareToPlay()
                myAudioPlayer.volume = 1
                myAudioPlayer.play()
            } catch {
            }
        }else{
            
        }
    }
    
    
    func ReproducirVozConductor(_ url: String){
        //AUDIOSESSION
        do {
            let fileURL = NSURL(string:url)
            let soundData = NSData(contentsOf:fileURL as! URL)
            try vozConductor = AVAudioPlayer(data: soundData as! Data)
            vozConductor.prepareToPlay()
            vozConductor.delegate = self
            vozConductor.volume = 1.0
            vozConductor.play()
            self.reproduciendo = true
        } catch {
            print("Nada de audio")
        }
        
        /* let playerItem = AVPlayerItem(url: URL(string: url)!)
         myPlayer = AVPlayer(playerItem:playerItem)
         myPlayer.rate = 1.0
         myPlayer.play()
         
         myPlayer = AVAudioPlayer(contentsOf: URL(string: url)!)
         myPlayer.rate = 1.0
         myPlayer.play()*/
    }
    
    func ReproducirMusica(){
        myMusica.play()
    }
    
    func SubirAudio(_ UrlSubirVoz: String, name: String){
        // The variable "recordedFileURL" is defined earlier in the code like this
        
        myvariables.SMSProceso = true
        self.ReproducirMusica()
        let currentFilename = name
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //let docsDir: AnyObject=dirPaths[0]
        let recordedFilePath = NSHomeDirectory() + "/Library/Caches/Audio" + name
        //docsDir.stringByAppendingPathComponent(self.currentFilename)
        let recordedFileURL = URL(fileURLWithPath: recordedFilePath)
        
        // "currentFilename", "recordedFilePath" and "recordedFileURL" are all global variables
        
        // This recording stored at "recordedFileURL" can be played back fine.
        
        let sendToPath = UrlSubirVoz
        let sendToURL = URL(string: sendToPath)
        let recording: Data? = try? Data(contentsOf: recordedFileURL)
        let boundary = "--------14737809831466499882746641449----"
        let beginningBoundary = "--\(boundary)"
        let endingBoundary = "--\(boundary)--"
        let contentType = "multipart/form-data;boundary=\(boundary)"
        
        let filename = recordedFilePath ?? currentFilename
        let header = "Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"\(currentFilename)\"\r\n"
        
        let request = NSMutableURLRequest()
        request.url = sendToURL
        request.httpMethod = "POST"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        //request.addValue(recId, forHTTPHeaderField: "REC-ID") // recId is defined elsewhere
        
        let body = NSMutableData()
        body.append(("\(beginningBoundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append((header as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: application/octet-stream\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(recording!) // adding the recording here
        body.append(("\r\n\(endingBoundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        let task : URLSessionTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let dataStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        })
        task.resume()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.vozConductor.stop()
        self.ReproducirMusica()
        self.reproduciendo = false
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}


