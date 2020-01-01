//
//  CGFloat+Random.swift
//  CircleHero
//
//  Created by Sroik on 9/24/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import UIKit

extension CGFloat {

    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
    
    static func random(_ from: CGFloat, to: CGFloat) -> CGFloat {
        return self.random()*(to - from) + from
    }
    
}
