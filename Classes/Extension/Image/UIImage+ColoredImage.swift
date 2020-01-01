//
//  UIImage+ColoredRect.swift
//  BallCatapult
//
//  Created by Sroik on 5/18/15.
//  Copyright (c) 2015 Sroik. All rights reserved.
//

import UIKit

extension UIImage {

    class func coloredImage(color: UIColor) -> UIImage {
        let contextRect = CGRect(x: 0, y: 0, width: 1.0 , height: 1.0)

        UIGraphicsBeginImageContext(contextRect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(contextRect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage!
    }

    class func imageWithImage(_ image:UIImage, color: UIColor) -> UIImage? {
        let maskImage = image.cgImage
        let imageScale = image.scale
        
        let bounds = CGRect(x: 0, y: 0, width: image.size.width*imageScale, height: image.size.height*imageScale)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        let bitmapContext = CGContext(data: nil, width: Int(bounds.width), height: Int(bounds.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
        
        
        bitmapContext?.clip(to: bounds, mask: maskImage!)
        bitmapContext?.setFillColor(color.cgColor)
        bitmapContext?.fill(bounds)
        
        let bitmapContent = bitmapContext?.makeImage()
        
        let result = UIImage(cgImage: bitmapContent!)
        
        return result
    }

}
