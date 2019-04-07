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
//        let h = Int(self.hsl.hue*360)
//        var name = ""
//        if (h >= 11 && h <= 20) {
//            name = "red-orange"
//        } else if (h > 20 && h <= 40) {
//            name = "orange and brown"
//        } else if (h > 40 && h <= 50) {
//            name = "orange-yellow"
//        } else if (h > 50 && h <= 60) {
//            name = "yellow"
//        } else if (h > 60 && h <= 80) {
//            name = "yellow-green"
//        } else if (h > 80 && h <= 140 ) {
//            name = "green"
//        } else if (h > 140 && h <= 169) {
//            name = "green-cyan"
//        } else if (h > 169 && h <= 200) {
//            name = "cyan"
//        } else if ( h > 200 && h <= 220) {
//            name = "cyan-blue "
//        } else if (h > 220 && h <= 240) {
//            name = "blue"
//        } else if (h > 240 && h <= 280) {
//            name = "cyan-blue"
//        } else if (h > 280 && h <= 320) {
//            name = "magenta"
//        } else if (h > 320 && h <= 330) {
//            name = "magenta-mink"
//        } else if (h > 330 && h <= 345) {
//            name = "pink"
//        } else if (h > 345 && h <= 355) {
//            name = "pink-red"
//        } else {
//            name = "red"
//        }
//        return name
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



