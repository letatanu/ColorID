//
//  Extension_UIImage.swift
//  ColorID
//
//  Created by Le Nhut on 4/3/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Darwin
extension UIImage {
    
    private func makeBytesFromCompatibleImage(_ image: CGImage) -> [UInt8]? {
        guard let dataProvider = image.dataProvider else {
            return nil
        }
        guard let data = dataProvider.data else {
            return nil
        }
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }
    
    private func makeBytesFromIncompatibleImage(_ image: CGImage) -> [UInt8]? {
        let width = image.width
        let height = image.height
        var rawData = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
                return nil
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return rawData
    }
    private func isCompatibleImage(_ cgImage: CGImage) -> Bool {
        guard let colorSpace = cgImage.colorSpace else {
            return false
        }
        if colorSpace.model != .rgb {
            return false
        }
        let bitmapInfo = cgImage.bitmapInfo
        let alpha = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let alphaRequirement = (alpha == CGImageAlphaInfo.noneSkipLast.rawValue || alpha == CGImageAlphaInfo.last.rawValue)
        let byteOrder = bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue
        let byteOrderRequirement = (byteOrder == CGBitmapInfo.byteOrder32Little.rawValue)
        if !(alphaRequirement && byteOrderRequirement) {
            return false
        }
        if cgImage.bitsPerComponent != 8 {
            return false
        }
        if cgImage.bitsPerPixel != 32 {
            return false
        }
        if cgImage.bytesPerRow != cgImage.width * 4 {
            return false
        }
        return true
    }
    
    func makeBytes() -> [UInt8]? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        if isCompatibleImage(cgImage) {
            return makeBytesFromCompatibleImage(cgImage)
        } else {
            return makeBytesFromIncompatibleImage(cgImage)
        }
    }
    var averageColor: UIColor? {
        var result = [UIColor]()
        guard let img = self.cgImage else { return nil }
        let width = img.width
        let height = img.height
        guard let byteData = self.makeBytes() else { return nil}
        
        let d = min(width, height)
        let r = Int(d/2)
        
        for x in 0..<width {
            for y in 0..<height {
                //just get the pixels in the circle
                if  (x-r)*(x-r) + (y-r)*(y-r) <= r*r {
                    let pixelIndex = ((width * y) + x) * 4
                    let red = CGFloat(byteData[pixelIndex + 3]) / CGFloat(255.0)
                    let green = CGFloat(byteData[pixelIndex + 2]) / CGFloat(255.0)
                    let blue = CGFloat(byteData[pixelIndex + 1]) / CGFloat(255.0)
                    let alpha = CGFloat(1)
                    
                    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                    result.append(color)
                }
            }
        }
        return result.average
    }
    
    
    func isEqual( to: UIImage) -> Bool {
        
        guard let data1 = UIImagePNGRepresentation(self) else { return false }
        guard let data2 = UIImagePNGRepresentation(to) else { return false }
        return data1==data2
    }
    
    func mostDominantColor(inNumberOfCluster numberOfCluster: Int = 9) -> UIColor? {
    
        var result = [UIColor]()
        guard let img = self.cgImage else { return nil }
        let width = img.width
        let height = img.height
        guard let byteData = self.makeBytes() else { return nil}
        
        let d = min(width, height)
        let r = Int(d/2)
        
        for x in 0..<width {
            for y in 0..<height {
                //just get the pixels in the circle
                if  (x-r)*(x-r) + (y-r)*(y-r) <= r*r {
                    let pixelIndex = ((width * y) + x) * 4
                    let red = CGFloat(byteData[pixelIndex + 3]) / CGFloat(255.0)
                    let green = CGFloat(byteData[pixelIndex + 2]) / CGFloat(255.0)
                    let blue = CGFloat(byteData[pixelIndex + 1]) / CGFloat(255.0)
                    let alpha = CGFloat(1)
                    
                    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                    result.append(color)
                }
            }
        }
        let clusters = Classifier.init(numberOfCluster, result)
        //        print(clusters.getClusters)
        return clusters.mostDominantColor
    }
    
    func equal(_ p: UIImage) -> Bool {
        guard let leftByteData = self.makeBytes() else { return false}
        guard let rightByteData = p.makeBytes() else {return false}
        let lLen = leftByteData.count
        let rLen = rightByteData.count
        if lLen != rLen { return false}
        for i in 0 ..< lLen {
            if (i+1)%4 != 0 {
                if leftByteData[i] != rightByteData[i] {return false}
            }
        }
        return true
    }
    
    func imageByApplyingClippingCenterCircleBezierPath(radius: CGFloat, lineWidth: CGFloat, center: CGPoint) -> UIImage {
        // Mask image using path
        let path = UIBezierPath(
            arcCenter: center,
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
