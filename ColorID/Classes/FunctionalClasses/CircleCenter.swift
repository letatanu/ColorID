//
//  CircleCenter.swift
//  ColorID
// It draws the circle and adds to specific views
//  Created by Nhut Le on 9/8/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class CirclePoint: NSObject {
    fileprivate var location: CGPoint?
    fileprivate var radius: CGFloat
    fileprivate var lineWidth: CGFloat
    fileprivate var presentationLayer: CALayer?
    var currentRecCenter = CAShapeLayer()
    init(presentationLayer: CALayer, centerLocation: CGPoint?, radius: CGFloat, lineWidth: CGFloat = NumericalData.shared().lineWidth) {
        
        self.location = centerLocation
        self.radius = radius
        self.lineWidth = lineWidth
        self.presentationLayer = presentationLayer
        super.init()
        if let recC = self.recCenter() {
            self.currentRecCenter = recC
            self.presentationLayer?.addSublayer(self.currentRecCenter)
        }
//       r initGestureRecognizers()

    }
    func getRadius() -> CGFloat {
        return self.radius
    }
    
    func changeStatus(newLocation: CGPoint?, newLineWidth: CGFloat?, newRadius: CGFloat?) {
        
        guard (newLocation != nil || newLineWidth != nil || newRadius != nil) else {return}
        if let newPoint: CGPoint = newLocation {
            self.currentRecCenter.removeFromSuperlayer()
            self.location = newPoint
        }
        if let newRad: CGFloat = newRadius {
            self.currentRecCenter.removeFromSuperlayer()
            self.radius = newRad
                
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
        guard (self.currentRecCenter.superlayer != nil) else {return}
        self.currentRecCenter.removeFromSuperlayer()
    }
    // rendering a circle with given parameters
    func recCenter() -> CAShapeLayer? {
        guard let centerPoint = self.location else { return nil}
        let rec = CAShapeLayer()
       
        let smallCircle = UIBezierPath(
            arcCenter: centerPoint,
            radius: self.radius - self.lineWidth*0.5,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
        let bigCircle = UIBezierPath(arcCenter: centerPoint, radius: self.radius+2, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        
        let shapeLayerPath = UIBezierPath()
        shapeLayerPath.append(bigCircle)
        shapeLayerPath.append(smallCircle)
        rec.path = shapeLayerPath.cgPath
        rec.fillColor = UIColor.black.cgColor
        rec.fillRule = CAShapeLayerFillRule.evenOdd
        rec.strokeColor = UIColor.white.cgColor
        rec.lineWidth = self.lineWidth
        rec.opacity = 1
        return rec
    }
}
extension CirclePoint {
    func imageInCircle(orginalImage: UIImage, actualLocation: CGPoint?) -> UIImage? {
        guard var loc: CGPoint = self.location else { return UIImage()}
        if let actLocation = actualLocation {
            loc.x -= actLocation.x
            loc.y -= actLocation.y
        }
        let path =  UIBezierPath(cgPath: self.currentRecCenter.path!)
        guard let finalImg = orginalImage.imageByApplyingClippingCenterCircleBezierPath(path: path) else { return nil }
        
        return finalImg
    }
}
