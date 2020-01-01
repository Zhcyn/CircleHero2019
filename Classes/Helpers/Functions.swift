//
//  Functions.swift
//  CircleHero
//
//  Created by Sroik on 9/24/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import UIKit

func degreeToRadians(_ degree: CGFloat) -> CGFloat {
    return (CGFloat(M_PI)*degree)/180.0;
}

func arcAngleForLength(_ length: CGFloat, arcRadius: CGFloat) -> CGFloat {
    let circleLength = arcRadius*2.0*CGFloat(M_PI)
    let arcCoeff = length/circleLength
    let angle = arcCoeff*360.0
    
    return angle
}


