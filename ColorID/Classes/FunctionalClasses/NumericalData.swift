//
//  NumericalData.swift
//  ColorID
// This is a singletone that returns specific numerical values
//  Created by Nhut Le on 7/27/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit


final class NumericalData {
    let largeFontSize: CGFloat
    let smallFontSize: CGFloat
    let centerPoint: CGPoint
    let lineWidth: CGFloat
    let defaultSizeOfCircle: CGFloat
    private static var sharedNumericalData: NumericalData = {
        let tmp = NumericalData()
        return tmp
    }()
    class func shared() -> NumericalData {
        return sharedNumericalData
    }
    
    init() {
        self.centerPoint = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
        lineWidth = 1
        defaultSizeOfCircle = 10
        largeFontSize = 31*UIScreen.main.bounds.width/750
        smallFontSize = 13*UIScreen.main.bounds.width/750
    }
}
