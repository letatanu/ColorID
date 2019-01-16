//
//  ColorDict.swift
//  ColorID
//
//  Created by Le Nhut on 8/11/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class colorDict {
    private var data = [String:String]()
    private static var ColorDictionary: colorDict = {
        let colorDictionary = colorDict()
        return colorDictionary
    }()
    private var color = UIColor()
    private var ColorFamilies = [
        ["e6194b", "Red"],
        ["fabebe", "Pink"],
        ["f58231", "Orange"],
        ["ffe119", "Yellow"],
        ["911eb4", "Purple"],
        ["3cb44b", "Green"],
        ["0000FF", "Blue"],
        ["aa6e28", "Brown"],
        ["FFFFFF", "White"],
        ["000000", "Black"]
    ]
    private init(dataName: String = "ColorDict"){
        if let content = try? String(contentsOfFile: dataName) {
            let lines = content.components(separatedBy: "\n")
            for line in lines {
                let colorVals = line.components(separatedBy: ":")
                guard colorVals.count == 2 else {
                    return
                }
                self.data[colorVals[0]] = colorVals[1]
            }
        }
    }
    class func shared() -> colorDict {
        return ColorDictionary
    }
    
    func getClosestColorName(for Color: UIColor) -> String {
        var distance = 99999.0
        var name = ""
        for color in colorDict.shared().data {
                let value = color.key
                let cName = color.value
                let newColor = UIColor.init(hex: value)
                let rgb = newColor.rgb()
            let hsl = newColor.rgbToHSL(r: (rgb?.red)!, g: (rgb?.green)!, b: (rgb?.blue)!)
                let newDistance = self.color.distance(newColor)
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
    
    func getClosestColorFamily() -> String {
        var distance = 99999.0
        var name = ""
       
        for color in self.ColorFamilies {
            let value = color[0]
            let cName = color[1]
            let newColor = UIColor.init(hex: value)
            let newDistance = self.color.distance(newColor)
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

