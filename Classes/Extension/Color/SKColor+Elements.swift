//
//  UIColor+Elements.swift
//  KeepRhythm
//
//  Created by Sroik on 8/5/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

extension SKColor {
    
    class func randomColor() -> SKColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        
        let color = SKColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    
    class func randomParticleColor() -> SKColor {
        return randomColorFromColors(particleColors())
    }
    
    class func randomColorFromColors(_ colors: Array<SKColor>) -> SKColor {
        let randIndex: Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randIndex]
    }
    
    class func particleColors() -> Array<SKColor> {
        return Array(arrayLiteral: SKColor.colorWithHex("F4F671"),
        SKColor.colorWithHex("F470B3"),
        SKColor.colorWithHex("43EFCE"),
        SKColor.colorWithHex("5BEE75"),
        SKColor.colorWithHex("5BDDEE"),
        SKColor.colorWithHex("C27DE6"))
    }
    
    
}
