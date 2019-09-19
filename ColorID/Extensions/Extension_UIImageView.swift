//
//  Extension_UIImageView.swift
//  ColorID
//
//  Created by Nhut Le on 9/18/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func calculateClientRectOfImageInUIImageView () -> CGRect?{
        let imgViewSize = self.frame.size
        guard var imgSize = self.image?.size else {return nil}
        let scaleW : CGFloat = imgViewSize.width/imgSize.width
        let scaleH : CGFloat = imgViewSize.height/imgSize.height
        let aspect = min(scaleW, scaleH)
        imgSize.width *= aspect
        imgSize.height *=  aspect
        var imgRect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: imgSize.width, height: imgSize.height))
        
        imgRect.origin.x = (imgViewSize.width-imgRect.size.width)/2
        imgRect.origin.y = (imgViewSize.height-imgRect.size.height)/2
        imgRect.origin.x+=self.frame.origin.x;
        imgRect.origin.y+=self.frame.origin.y;
        return imgRect
    }
}
