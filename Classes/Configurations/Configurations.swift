//
//  Configurations.swift
//  CircleHero
//
//  Created by Sroik on 8/5/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

let kLeftBottomAnchor = CGPoint(x: 0.0, y: 0.0)
let kLeftTopAnchor = CGPoint(x: 0.0, y: 1.0)
let kCenterAnchor = CGPoint(x: 0.5, y: 0.5)
let kCenterBottomAnchor = CGPoint(x: 0.5, y: 0.0)
let kCenterTopAnchor = CGPoint(x: 0.5, y: 1.0)
let kLeftCenterAnchor = CGPoint(x: 0.0, y: 0.5)
let kRightCenterAnchor = CGPoint(x: 1.0, y: 0.5)
let kRightTopAnchor = CGPoint(x: 1.0, y: 1.0)

let isPhone = (UI_USER_INTERFACE_IDIOM() == .phone)

let kDefaultAnimationDuration: TimeInterval = 0.25
