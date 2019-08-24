//
//  ColorDict.swift
//  ColorID
//
//  Created by Le Nhut on 8/11/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class colorDict {
    public var data = [String:String]()
    private static var ColorDictionary: colorDict = {
        let colorDictionary = colorDict()
        return colorDictionary
    }()
    private var color = UIColor()
    
    public var ColorFamilies = [
        ["FF0000","Đỏ"],
        ["FF7F00", "Cam"],
        ["FFFF00", "Vàng"],
        ["50C878", "Lục"],
        ["0000FF", "Lam"],
        ["4B0082", "Chàm"],
        ["8F00FF", "Tím"],
        ["000000", "Đen"],
        ["FFFFFF", "Trắng"],
        
    ]
    private init(dataName: String = "ColorDict_viet"){
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

