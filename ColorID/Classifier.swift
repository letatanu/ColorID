//
//  Classifier.swift
//  ColorID
//
//  Created by Le Nhut on 8/1/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Classifier: NSObject {
    private var k = 0
    private var values: [Pixel]
    
    init(_ K: Int) {
        self.values = []
        self.k = K
    }
    
    func addPixel(_ p: Pixel) {
        values.append(p)
    }
    
    
}
