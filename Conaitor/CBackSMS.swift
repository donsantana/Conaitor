//
//  CBackSMS.swift
//  Rocostcar
//
//  Created by Done Santana on 5/4/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class CBackSMS: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, AVAudioPlayerDelegate {
    
    var myPlayer = AVPlayer()
    var myMusica = AVAudioPlayer()
    var myAudioPlayer = AVAudioPlayer()
    var playSession = AVAudioSession()
    var vozConductor = AVAudioPlayer()
    
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
        do{
            let session = AVAudioSession.sharedInstance()
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default)
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playback.rawValue, with:  [])
            }
            try session.setActive(true)
        }catch{
            print("Problem")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //para reproducir audio de internet
    func PlayForInternet(_ url: String){
        let url = url
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        myPlayer = AVPlayer(playerItem:playerItem)
        myPlayer.rate = 1.0
        myPlayer.play()
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.vozConductor.stop()
        self.ReproducirMusica()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

