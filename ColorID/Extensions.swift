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
    convenience init(hexString:String) {
        let scanner = Scanner(string: hexString as String)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    var hsl:(hue:CGFloat, sarturation:CGFloat, brightness:CGFloat) {
        let minV:CGFloat = CGFloat(min(self.redValue, self.greenValue, self.blueValue))
        let maxV:CGFloat = CGFloat(max(self.redValue, self.greenValue, self.blueValue))
        let delta:CGFloat = maxV - minV
        var hue:CGFloat = 0
        if delta != 0 {
            if self.redValue == maxV {
                hue = (self.greenValue - self.blueValue) / delta
            }
            else if self.greenValue == maxV {
                hue = 2 + (self.blueValue - self.redValue) / delta
            }
            else {
                hue = 4 + (self.redValue - self.greenValue) / delta
            }
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        let s = maxV == 0 ? 0 : (delta / maxV)
        let b = maxV
        return (hue/360, s, b)
    }
    static public func + (left: UIColor, right: UIColor) -> UIColor {
        return UIColor(red: left.redValue + right.redValue, green: left.greenValue + right.greenValue , blue: left.blueValue + right.blueValue, alpha: CGFloat(1) )
    }
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    static public func / (left: UIColor, right: CGFloat) -> UIColor {
        return UIColor(red: left.redValue/right, green: left.greenValue/right , blue: left.blueValue/right, alpha: 1)
    }
    var redValue: CGFloat { return self.rgba.red }
    var greenValue: CGFloat { return (self.rgba.green) }
    var blueValue: CGFloat { return (self.rgba.blue) }
    
    func isEqual(_ p: UIColor) -> Bool {
        if self.blueValue == p.blueValue && self.redValue == p.redValue && self.greenValue == p.greenValue {
            return true
        }
        return false
    }
    
    func distance(_ p: UIColor) -> Double {
        let df1 = pow((self.redValue - p.redValue),2) + pow((self.greenValue - p.greenValue),2) + pow((self.blueValue - p.blueValue),2)
        let df2 = pow((self.hsl.hue - p.hsl.hue),2) + pow((self.hsl.sarturation - p.hsl.sarturation),2) + pow((self.hsl.brightness - p.hsl.brightness),2)
        return Double(df1 + df2*df2)
    }
    
    // return the name of pixel color
    func name() -> String {
            var df = -1.0
            var cl = ""
            for color in colorDict.shared().data.keys {
                let cName = colorDict.shared().data[color]
                let newColor = UIColor.init(hexString: color)
                let newDistance = self.distance(newColor)
                if(df < 0 || df > newDistance)
                {
                    df = newDistance
                    cl = cName ?? ""
                }
                
            }
            return cl
    }
    func family() -> String {
        
            var distance = 99999.0
            var name = ""
            
        for color in colorDict.shared().ColorFamilies {
                let value = color[0]
                let cName = color[1]
                let newColor = UIColor.init(hexString: value)
                let newDistance = self.distance(newColor)
                if newDistance == 0.0 {
                    return cName
                }
                else if distance > newDistance {
                    distance = newDistance
                    name = cName
                }
            }
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
}
