//
//  CircleCenter.swift
//  ColorID
//
//  Created by Nhut Le on 9/8/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class CirclePoint: NSObject {
    fileprivate var location: CGPoint?
    fileprivate var radius: CGFloat = 1
    fileprivate var lineWidth: CGFloat = 1
    fileprivate var presentationLayer: CALayer?
    fileprivate var currentRecCenter = CAShapeLayer()
    init(presentationLayer: CALayer, centerLocation: CGPoint?, radius: CGFloat, lineWidth: CGFloat = CGFloat(1)) {
        self.location = centerLocation
        self.radius = radius
        self.lineWidth = lineWidth
        self.presentationLayer = presentationLayer
        super.init()
        if let recC = self.recCenter() {
            self.currentRecCenter = recC
            self.presentationLayer?.addSublayer(self.currentRecCenter)
        }
    }
    
    func changeStatus(newLocation: CGPoint?, newLineWidth: CGFloat?) {
        if let newPoint: CGPoint = newLocation {
            self.currentRecCenter.removeFromSuperlayer()
            self.location = newPoint
        }
        
        if let newWidth: CGFloat = newLineWidth {
            self.currentRecCenter.removeFromSuperlayer()
            self.lineWidth = newWidth
        }
        
        if let recC = self.recCenter() {
            self.currentRecCenter = recC
            self.presentationLayer?.addSublayer(self.currentRecCenter)
        }
        
    }
    
    func removeAll() {
        self.currentRecCenter.removeFromSuperlayer()
    }
    // rendering a circle with given parameters
    func recCenter() -> CAShapeLayer? {
        guard let centerPoint = self.location else { return nil}
        let rec = CAShapeLayer()
        rec.path = UIBezierPath(
            arcCenter: centerPoint,
            radius: self.radius - self.lineWidth*0.5,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true).cgPath
        rec.fillColor = UIColor.clear.cgColor
        rec.strokeColor = UIColor.white.cgColor
        rec.lineWidth = self.lineWidth
        rec.opacity = 1
        return rec
    }
    
    

}
