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
            radius: CGFloat(radius - lineWidth),
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
    
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        let contextImage = UIImage.init(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width < to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
        else if to.width > to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }
        else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }
            else { //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        UIGraphicsBeginImageContextWithOptions(to, true, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized!
    }
    
}

extension CGPath {
//    func forEach( body: @convention(block) (CGPathElement) -> Void) {
//        typealias Body = @convention(block) (CGPathElement) -> Void
//        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
//            let body = unsafeBitCast(info, to: Body.self)
//            body(element.pointee)
//        }
//        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
//        self.apply(info: unsafeBody, function: callback)
//    }
}

// Finds the first point in a path
//extension UIBezierPath {
//    func firstPoint() -> CGPoint? {
//        var firstPoint: CGPoint? = nil
//        
//        self.cgPath.forEach { element in
//            // Just want the first one, but we have to look at everything
//            guard firstPoint == nil else { return }
//            assert(element.type == .moveToPoint, "Expected the first point to be a move")
//            firstPoint = element.points.pointee
//        }
//        return firstPoint
//    }
//}
