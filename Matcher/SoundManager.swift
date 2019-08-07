//
//  SoundManager.swift
//  Matcher
//
//  Created by Lu Jack on 2019-02-22.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect: SoundEffect){
        
        var soundFilename = ""
        
        // determine effect
        // set appropriate filename
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        // get path from sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Sound file not found (\(soundFilename))")
            return
        }
        
        // create URL project from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        // create audio player object
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // playing sound
            audioPlayer?.play()
        }
        catch {
            print("Could not create audio player object for sound file \(soundFilename)")
        }
    }
}


