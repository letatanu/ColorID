//
//  extension.swift
//  ColorID
//
//  Created by Le Nhut on 7/11/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageByApplyingClippingCenterCircleBezierPath(radius: CGFloat, lineWidth: CGFloat) -> UIImage {
        // Mask image using path
        let path = UIBezierPath(
            arcCenter: CGPoint(x: size.width*0.5, y: size.height*0.5),
            radius: CGFloat(radius - lineWidth*0.5 ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        path.lineWidth = lineWidth
        let maskedImage = imageByApplyingMaskingCenterCircleBezierPath(path)

        // Crop image to frame of path
        let croppedImage = UIImage(cgImage: maskedImage.cgImage!.cropping(to: path.bounds)!)
        return croppedImage
    }
    
    private func imageByApplyingMaskingCenterCircleBezierPath(_ path: UIBezierPath) -> UIImage {
        // Define graphic context (canvas) to paint on
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
//        print(path.firstPoint())
        context.addPath(path.cgPath)
        context.clip()
        draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
    
}

extension CGPath {
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback)
    }
}

// Finds the first point in a path
extension UIBezierPath {
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil
        
        self.cgPath.forEach { element in
            // Just want the first one, but we have to look at everything
            guard firstPoint == nil else { return }
            assert(element.type == .moveToPoint, "Expected the first point to be a move")
            firstPoint = element.points.pointee
        }
        return firstPoint
    }
}
