//
//  SoundButton.swift
//  CircleHero
//
//  Created by Sroik on 9/23/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

class SoundButton: SKSpriteNode {

    var isEnabled: Bool = true
    var soundButton: Button!
    var soundButtonColor: SKColor!
    
    init(size: CGSize, color: SKColor) {
        super.init(texture: nil, color: SKColor.clear, size: size)
        
        self.soundButtonColor = color
        self.setupContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- setup methods
    
    fileprivate func setupContent() {
        self.soundButton = Button(imageNamed: self.currentSoundImageName(), color: self.soundButtonColor)

        self.soundButton.size = self.size
        self.soundButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
     
        self.addChild(self.soundButton)
    }
    
    
    fileprivate func currentSoundImageName() -> String {
        let name = self.isEnabled ? "sound_on.png" : "sound_off.png"
        return name
    }

//MARK: public
    
    func setTarget(_ target: AnyObject, action: Selector) {
        self.soundButton.setTarget(target, action: action)
    }

    func setEnabled(_ isEnable: Bool) {
        self.isEnabled = isEnable

        let soundImage = UIImage.imageWithImage(UIImage(named:self.currentSoundImageName())!, color: self.soundButtonColor)
        self.soundButton.texture = SKTexture(image: soundImage!)
    }
    
}
