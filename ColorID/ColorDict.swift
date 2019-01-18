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

