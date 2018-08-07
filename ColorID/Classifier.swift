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
import Accelerate
import Darwin

typealias Vectors = Array<[UIColor]>
typealias Vector = [UIColor]

class Classifier: NSObject {
    static let sharedInstance = Classifier()
    private var k = 0
    private var values: Vector = Vector()
    private var clusters: Vectors = Vectors()
    private var centroids: Vector = Vector()
    private var maxInterator: Int = 400
    
    //Initialization
    init(_ K: Int = 1, _ _values: [UIColor] = []) {
        super.init()
        self.values = []
        self.k = K
        for value in _values {
            self.addPixel(value)
        }
    }
    
    //Adding an pixel to data
    func addPixel(_ p: UIColor) {
        self.values.append(p)
    }
    
    //Updating new centroids
    private func updateCentroids () {
        
    }
    
    //Running clustering in data
    func clustering() {
        
    }
    
    
    
    
}
