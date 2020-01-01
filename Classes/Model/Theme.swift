//
//  Theme.swift
//  CircleHero
//
//  Created by Sroik on 9/25/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

class Theme: NSObject {

    var backgroundColor: SKColor = SKColor.black
    var fragmentsColor: SKColor = SKColor.white
    var indicatorColor: SKColor = SKColor.red
    var targetColor: SKColor = SKColor.green
    var bestScoreColor: SKColor = SKColor.blue
    
    class func darkTheme() -> Theme {
        let theme = Theme()
        
        theme.backgroundColor = SKColor.colorWithHex("484061")
        theme.indicatorColor = SKColor.colorWithHex("F04B4B")
        theme.fragmentsColor = SKColor.colorWithHex("D9D9D9")
        theme.targetColor = SKColor.colorWithHex("5DA841")
        theme.bestScoreColor = SKColor.colorWithHex("4FBAF5")
        
        return theme
    }
    
    class func lightTheme() -> Theme {
        let theme = Theme()
        
        theme.backgroundColor = SKColor.colorWithHex("D9D9D9")
        theme.indicatorColor = SKColor.colorWithHex("F04B4B")
        theme.fragmentsColor = SKColor.colorWithHex("5A5A5A")
        theme.targetColor = SKColor.colorWithHex("5DA841")
        theme.bestScoreColor = SKColor.colorWithHex("6C6C6C")
        
        return theme
    }
    
}
