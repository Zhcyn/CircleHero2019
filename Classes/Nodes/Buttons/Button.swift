//
//  Button.swift
//  KeepRhythm
//
//  Created by Sroik on 8/5/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

private let kSelectedOpacity: CGFloat = 0.5

class Button: SKSpriteNode {
    
    fileprivate(set) var isSelected: Bool = false
    var isEnabled: Bool = true
    
    fileprivate(set) weak var target: AnyObject?
    fileprivate(set) var action: Selector?
   
    init(imageNamed name: String, color: SKColor) {
        let buttonImage = UIImage.imageWithImage(UIImage(named: name)!, color: color)
        let texture = SKTexture(image: buttonImage!)
        super.init(texture: texture, color: UIColor.yellow, size: texture.size())
        
        self.isUserInteractionEnabled = true
        self.anchorPoint = kCenterAnchor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- public methods
    
    func setTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
//MARK:- touches handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isEnabled {
            return
        }
        
        self.isSelected = true
        self.alpha = kSelectedOpacity
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isEnabled {
            return
        }
        
        let point = touches.first!.location(in: self) as CGPoint
        if self.pointInside(point) {
            self.isSelected = true
            self.alpha = kSelectedOpacity
        } else {
            self.isSelected = false
            self.alpha = 1.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        
        if !isEnabled || !isSelected {
            return
        }
        
        let point = touches.first!.location(in: self) as CGPoint
        if self.pointInside(point) {
            _ = self.target?.perform(self.action!)
        }
    }
    
    func pointInside(_ point: CGPoint) -> Bool {
        let insideRadius = self.size.width*pow(2.0,0.5)/2.0
        let isInside = pow(pow(point.x,2.0) + pow(point.y, 2.0), 0.5) < insideRadius
        return isInside
    }
}
