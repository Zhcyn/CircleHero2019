//
//  df.swift
//  CircleHero
//
//  Created by Sroik on 10/8/14.
//  Copyright © 2014 Sroik. All rights reserved.
//

import UIKit

extension UIBezierPath {

    class func arcPathWithRadius(_ radius: CGFloat, angle: CGFloat, width: CGFloat) -> UIBezierPath {
        let radians = degreeToRadians(angle)
        
        let smallRadius = radius - width/2.0
        let bigRadius = radius + width/2.0
        
        let cp1 = CGPoint(x: 0, y: smallRadius)
        let cp2 = CGPoint(x: 0, y: bigRadius)
//        let cp3 = CGPointMake(bigRadius*sin(radians), bigRadius*cos(radians))
        let cp4 = CGPoint(x: smallRadius*sin(radians), y: smallRadius*cos(radians))
        
        let path = UIBezierPath()
        path.move(to: cp1)
        path.addLine(to: cp2)
        path.addArc(withCenter: CGPoint.zero, radius: bigRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2) - radians, clockwise: false)
        path.addLine(to: cp4)
        path.addArc(withCenter: CGPoint.zero, radius: smallRadius, startAngle: CGFloat(M_PI_2) - radians, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.close()
        
        return path
    }
}
