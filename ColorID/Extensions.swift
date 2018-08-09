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
        return UIColor(red: left.redValue + right.redValue, green: left.greenValue + right.greenValue , blue: left.blueValue + right.blueValue, alpha: CGFloat(1) )
    }
    public func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:fRed, green:fGreen, blue:fBlue)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    static public func / (left: UIColor, right: CGFloat) -> UIColor {
        return UIColor(red: left.redValue/right, green: left.greenValue/right , blue: left.blueValue/right, alpha: 1)
    }
    var redValue: CGFloat { return (self.rgb()?.red)! }
    var greenValue: CGFloat { return (self.rgb()?.green)! }
    var blueValue: CGFloat { return (self.rgb()?.blue)! }
    
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
    func isEqual( to: UIImage) -> Bool {
        
        guard let data1 = UIImagePNGRepresentation(self) else { return false }
        guard let data2 = UIImagePNGRepresentation(to) else { return false }
        return data1==data2
    }
    func mostDominantColor(inNumberOfCluster numberOfCluster: Int = 3) -> UIColor? {
        var result = [UIColor]()
        guard let img = self.cgImage else { return nil }
        let width = img.width
        let height = img.height
        let imageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let bitmapBytesForRow = Int(width * 4)
        let bitmapByteCount = bitmapBytesForRow * Int(height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapMemory = malloc(bitmapByteCount)
        let bitmapInformation = CGImageAlphaInfo.premultipliedFirst.rawValue
        
        let colorContext = CGContext(data: bitmapMemory, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesForRow, space: colorSpace, bitmapInfo: bitmapInformation)
        
        colorContext!.clear(imageRect)
        colorContext?.draw(img, in: imageRect)
        
        guard let data = colorContext?.data else {return nil}
        let dataType = data.assumingMemoryBound(to: UInt8.self)
        let numberOfComponents = 4
        
        let d = min(width, height)
        let r = Int(d/2)
        
        for x in 0..<width {
            for y in 0..<height {
                //just get the pixels in the circle
                if  (x-r)*(x-r) + (y-r)*(y-r) <= r*r {
                    let pixelIndex = ((width * y) + x) * numberOfComponents
                    let red = CGFloat(dataType[pixelIndex]) / CGFloat(255.0)
                    let green = CGFloat(dataType[pixelIndex + 1]) / CGFloat(255.0)
                    let blue = CGFloat(dataType[pixelIndex + 2]) / CGFloat(255.0)
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
}
