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
    public var data = [String:String]()
    private static var ColorDictionary: colorDict = {
        let colorDictionary = colorDict()
        return colorDictionary
    }()
    private var color = UIColor()
    public var ColorFamilies = [
        ["FF0000", "Red"],
        ["FFC0CB", "Pink"],
        ["FFA500", "Orange"],
        ["FFFF00", "Yellow"],
        ["FF00FF", "Magenta"],
        ["008000", "Green"],
        ["0000FF", "Blue"],
        ["808080", "Grey"],
        ["FFFFFF", "White"],
        ["000000", "Black"],
        ["00FFFF", "Cyan"],
        ["800000", "Maroon"],
        ["800080", "Purple"]
    ]
    private init(dataName: String = "ColorDict"){
        if let filepath = Bundle.main.path(forResource: dataName, ofType: "txt") {
            if let content = try? String(contentsOfFile: filepath) {
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
    }
    class func shared() -> colorDict {
        return ColorDictionary
    }
    
    
}

