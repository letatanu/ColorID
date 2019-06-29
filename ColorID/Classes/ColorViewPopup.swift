//
//  ColorViewPopup.swift
//  ColorID
//
//  Created by Nhut Le on 6/26/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import UIKit

class ColorDetailPopupView: UIView {
    var color: UIColor {
        didSet {
            
        }
    }
    
   
    
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
