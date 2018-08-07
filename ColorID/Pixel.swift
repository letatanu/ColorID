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

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    func distance(_ p: UIColor) -> Double {
        var d = 0.0
        
        let rS: Double = Double((self.redValue - p.redValue) * (self.redValue - p.redValue))
        let gS: Double = Double((self.greenValue - p.greenValue) * (self.greenValue - p.greenValue))
        let bS: Double = Double((self.blueValue - p.blueValue) * (self.blueValue - p.blueValue))
        d = sqrt(rS + gS + bS)
        
        return d
    }
    
    // return the name of pixel color
    func name() -> String {
        let name = ""
        return name
    }
}
