//
//  AudioConverter.swift
//  XTaxi
//
//  Created by Done Santana on 27/7/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import TSVoiceConverter

let kAudioFileTypeWav = "wav"
let kAudioFileTypeAmr = "amr"
private let kAmrRecordFolder = "ChatAudioAmrRecord"   //存 amr 的文件目录名
private let kWavRecordFolder = "ChatAudioWavRecord"  //存 wav 的文件目录名

class AudioConverter {
    
    let amrPath = NSBundle.mainBundle().pathForResource("audio", ofType: "amr")
    let wavPath = NSBundle.mainBundle().pathForResource("audio", ofType: "wav")
    
    let amrTargetPath = AudioFolderManager.amrPathWithName("test_amr").path!
    let wavTargetPath = AudioFolderManager.wavPathWithName("test_wav").path!
    
    init(){
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func ConvertAmrToWav(urlOrigenAmr: String)->String{
        if TSVoiceConverter.convertAmrToWav(urlOrigenAmr, wavSavePath: wavTargetPath) {
            return wavTargetPath
            
        } else {
           return "false"
        }

    }
    func convertWavToAmr(urlOrigenWav: String)->String{
        if TSVoiceConverter.convertWavToAmr(urlOrigenWav, amrSavePath: amrTargetPath) {
            return amrTargetPath
        } else {
            return "false"
        }
    }
}

class AudioFolderManager {
    /**
     返回 amr 的完整路径
     
     - parameter fileName: 文件名字，不包含后缀
     
     - returns: 返回路径
     */
    class func amrPathWithName(fileName: String) -> NSURL {
        let filePath = self.amrFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeAmr)")
        return filePath
    }
    
    
    /**
     返回 wav 的完整路径
     
     - parameter fileName: 文件名字，不包含后缀
     
     - returns: 返回路径
     */
    class func wavPathWithName(fileName: String) -> NSURL {
        let filePath = self.wavFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeWav)")
        return filePath
    }
    
    /**
     创建录音的文件夹, amr 格式
     */
    private class var amrFilesFolder: NSURL {
        get { return self.createAudioFolder(kAmrRecordFolder)}
    }
    
    /**
     创建录音的文件夹, wav 格式
     */
    private class var wavFilesFolder: NSURL {
        get { return self.createAudioFolder(kWavRecordFolder)}
    }
    
    /**
     创建录音的文件夹
     */
    class private func createAudioFolder(folderName :String) -> NSURL {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        let folder = documentsDirectory.URLByAppendingPathComponent(folderName)
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(folder.absoluteString) {
            do {
                try fileManager.createDirectoryAtPath(folder.path!, withIntermediateDirectories: true, attributes: nil)
                return folder
            } catch let error as NSError {
                print("error:\(error)")
            }
        }
        return folder
    }
}
