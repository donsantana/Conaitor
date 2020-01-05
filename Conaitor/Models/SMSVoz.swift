////
////  SMSVoz.swift
////  UnTaxi
////
////  Created by Donelkys Santana on 5/9/19.
////  Copyright © 2019 Done Santana. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//
//
//class SMSVoz {
//    var recordingSession: AVAudioSession!
//    var audioRecorder: AVAudioRecorder!
//    
//    
//    init() {
//        recordingSession = AVAudioSession.sharedInstance()
//        
//        do {
//            if #available(iOS 10.0, *) {
//                try recordingSession.setCategory(.playAndRecord, mode: .default)
//            } else {
//                // Fallback on earlier versions
//            }
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        //self.loadRecordingUI()
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
//        } catch {
//            // failed to record!
//        }
//    }
//    
//    func startRecording() {
//        let audioFilename = directoryURL()
//        
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//        
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//            
//            recordButton.setTitle("Tap to Stop", for: .normal)
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    
//    func directoryURL() -> URL? {
//        let fileManager = FileManager.default
//        //var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
//        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        //let urls = NSHomeDirectory() + "/Library/Caches/audio.m4a"
//        let documentDirectory = urls[0] as URL
//        let soundURL = documentDirectory.appendingPathComponent("audio.m4a")
//        //let soundURL = NSURL.fileURLWithPath(urls as String)
//        return soundURL
//    }
//    
//}
