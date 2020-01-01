//
//  ThemeButton.swift
//  CircleHero
//
//  Created by Sroik on 9/23/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

class ThemeButton: SKSpriteNode {

    var isDark: Bool = true
    var themeButton: Button!
    var themeButtonColor: SKColor!
    
    init(size: CGSize, color: SKColor) {
        super.init(texture: nil, color: SKColor.clear, size: size)
        
        self.themeButtonColor = color
        self.setupContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- setup methods
    
    fileprivate func setupContent() {
        self.themeButton = Button(imageNamed: self.currentThemeImageName(), color: self.themeButtonColor)

        self.themeButton.size = self.size
        self.themeButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
     
        self.addChild(self.themeButton)
    }
    
    
    fileprivate func currentThemeImageName() -> String {
        let name = self.isDark ? "moon.png" : "sun.png"
        return name
    }

//MARK: public
    
    func setTarget(_ target: AnyObject, action: Selector) {
        self.themeButton.setTarget(target, action: action)
    }

    func setDark(_ isDark: Bool) {
        self.isDark = isDark

        let image = UIImage.imageWithImage(UIImage(named:self.currentThemeImageName())!, color: self.themeButtonColor)
        self.themeButton.texture = SKTexture(image: image!)
    }
    
}
