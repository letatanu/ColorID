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
import Darwin
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
        let rS: Double = Double(abs(self.redValue - p.redValue))
        let gS: Double = Double(abs(self.greenValue - p.greenValue))
        let bS: Double = Double(abs(self.blueValue - p.blueValue))
        d = rS + gS + bS
        
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
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [kCIContextWorkingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1)
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
        print(clusters.getClusters)
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
}
