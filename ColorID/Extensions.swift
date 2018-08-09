//
//  Pixel.swift
//  ColorID
//
//  Created by Le Nhut on 8/1/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIColor {
    static public func + (left: UIColor, right: UIColor) -> UIColor {
        return UIColor(red: left.redValue + right.redValue, green: left.greenValue + right.greenValue , blue: left.blueValue + right.blueValue, alpha: left.alphaValue + right.alphaValue )
    }
    
    static public func / (left: UIColor, right: CGFloat) -> UIColor {
        return UIColor(red: left.redValue/right, green: left.greenValue/right , blue: left.blueValue/right, alpha: left.alphaValue/right)
    }
    var redValue: CGFloat { return CIColor(color: self).red }
    var greenValue: CGFloat { return CIColor(color: self).green }
    var blueValue: CGFloat { return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    func isEqual(_ p: UIColor) -> Bool {
        if self.blueValue == p.blueValue && self.redValue == p.redValue && self.greenValue == p.greenValue {
            return true
        }
        return false
    }
    
    func distance(_ p: UIColor) -> Double {
        var d = 0.0
        
        let rS: Double = Double((self.redValue - p.redValue) * (self.redValue - p.redValue))
        let gS: Double = Double((self.greenValue - p.greenValue) * (self.greenValue - p.greenValue))
        let bS: Double = Double((self.blueValue - p.blueValue) * (self.blueValue - p.blueValue))
        d = sqrt(rS + gS + bS)
        
        return d
    }
    
    // return the name of pixel color
    func name() -> String {
        let name = ""
        return name
    }
}

extension Array where Element: UIColor {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    var total: UIColor {
        var r = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        for element in self {
            r = r + element
        }
        return r
    }
    
    var average: UIColor {
        return isEmpty ? UIColor(red: 0, green: 0, blue: 0, alpha: 0) : total / CGFloat(self.count)
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [kCIContextWorkingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1)
    }
    
    func extractColor() -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        var color: UIColor? = nil
        
//        if pixel[3] > 0 {
//            let alpha:CGFloat = CGFloat(pixel[3]) / 255.0
//            let multiplier:CGFloat = alpha / 255.0
//
//            color = UIColor(red: CGFloat(pixel[0]) * multiplier, green: CGFloat(pixel[1]) * multiplier, blue: CGFloat(pixel[2]) * multiplier, alpha: alpha)
//        } else {
        
            color = UIColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)
//        }
        
        pixel.deallocate()
    
        return color!
}
    func clusters(_ numberOfCluster: Int = 3) -> Array<[UIColor]> {
        var result = [UIColor]()
        
        guard let img = self.cgImage else { return [result]}
        let width = img.width
        let height = img.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var rawData = [UInt8](repeating: 0, count: width * height * 4)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * (width-1)
        let bytesPerComponent = 8
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let context = CGContext(data: &rawData, width: width, height: height, bitsPerComponent: bytesPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        context?.draw(img, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
    
        for x in 0..<width {
            for y in 0..<height {
                let byteIndex = (bytesPerRow * x) + y * bytesPerPixel
                
                let red   = CGFloat(rawData[byteIndex]    ) / 255.0
                let green = CGFloat(rawData[byteIndex + 1]) / 255.0
                let blue  = CGFloat(rawData[byteIndex + 2]) / 255.0
                let alpha = CGFloat(rawData[byteIndex + 3]) / 255.0
                
                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                result.append(color)
            }
        }
        let clusters = Classifier.init(numberOfCluster, result)
        
        return clusters.getClusters
    }
}
