//
//  NumericalData.swift
//  ColorID
//
//  Created by Nhut Le on 7/27/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit


final class NumericalData {
    // Screen width.
    private var largeFontSize: CGFloat = 0.0
    private var smallFontSize: CGFloat = 0.0
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    private static var instance: NumericalData? = nil
    
    public static func getInstance() -> NumericalData {
        if (instance == nil) {
            instance = NumericalData()
        }
        return instance!
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    init() {
        largeFontSize = 31*screenWidth/750
        smallFontSize = 13*screenWidth/750
    }
}
