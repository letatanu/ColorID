//
//  extension.swift
//  ColorID
//
//  Created by Le Nhut on 7/11/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
    

extension CGPath {
//    func forEach( body: @convention(block) (CGPathElement) -> Void) {
//        typealias Body = @convention(block) (CGPathElement) -> Void
//        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
//            let body = unsafeBitCast(info, to: Body.self)
//            body(element.pointee)
//        }
//        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
//        self.apply(info: unsafeBody, function: callback)
//    }
}

// Finds the first point in a path
//extension UIBezierPath {
//    func firstPoint() -> CGPoint? {
//        var firstPoint: CGPoint? = nil
//        
//        self.cgPath.forEach { element in
//            // Just want the first one, but we have to look at everything
//            guard firstPoint == nil else { return }
//            assert(element.type == .moveToPoint, "Expected the first point to be a move")
//            firstPoint = element.points.pointee
//        }
//        return firstPoint
//    }
//}
