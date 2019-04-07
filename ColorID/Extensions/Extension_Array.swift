//
//  Extension_Array.swift
//  ColorID
//
//  Created by Le Nhut on 4/3/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import Darwin
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
