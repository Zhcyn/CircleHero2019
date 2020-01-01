//
//  SoundManager.swift
//  CircleHero
//
//  Created by Sroik on 9/25/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import UIKit
import AVFoundation

private let kSoundEnabledKey = "sound_is_enabled"

class SoundManager: NSObject {

    static let sharedManager = SoundManager()
    
    var soundEnabled: Bool = true
    var player: AVAudioPlayer?
    
    override init() {
        self.soundEnabled = UserDefaults.standard.bool(forKey: kSoundEnabledKey)
    }
    
    class func setSoundEnabled(_ isEnabled: Bool) {
        sharedManager.soundEnabled = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: kSoundEnabledKey)
    }
    
    class func isSoundEnabled() -> Bool {
        return sharedManager.soundEnabled
    }
    
    class func playClick() {
        self.playSoundWithName("click")
    }
    
    class func playWrong() {
        self.playSoundWithName("wrong")
    }
    
    class func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    class func playSoundWithName(_ name: String) {
        if (!sharedManager.soundEnabled) {
            return
        }
        
        let url = Bundle.main.url(forResource: name, withExtension: "m4a")
        
        do {
            sharedManager.player = try AVAudioPlayer(contentsOf: url!)
            sharedManager.player?.volume = 0.6
            sharedManager.player?.prepareToPlay()
            DispatchQueue.global().async(execute: {
                sharedManager.player?.play()
            })
        } catch {
            print("sound manager exeption: \(error)")
        }
    }
    
}
