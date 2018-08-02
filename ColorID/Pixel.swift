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

class Pixel: NSObject {
    private var R: Int = 0
    private var G: Int = 0
    private var B: Int = 0
    private var alpha: Int = 0
    
    init(_ R: Int, _ G: Int, _ B: Int, _ alpha: Int = 0) {
        self.R = R
        self.G = G
        self.B = B
        self.alpha = alpha
    }
    
    public func getValue() -> [Int] {
        return [self.R, self.G, self.B, self.alpha]
    }
    
    func distance(_ p: Pixel) -> Double {
        var d = 0.0
        
        let rS: Double = Double((self.R - p.getValue()[0]) * (self.R - p.getValue()[0]))
        let gS: Double = Double((self.G - p.getValue()[1]) * (self.G - p.getValue()[1]))
        let bS: Double = Double((self.B - p.getValue()[2]) * (self.B - p.getValue()[2]))
        d = sqrt(rS + gS + bS)
        
        return d
    }
    
    // return the name of pixel color
    func name() -> String {
        let name = ""
        return name
    }
}
