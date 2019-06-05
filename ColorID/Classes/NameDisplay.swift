//
//  NameDisplay.swift
//  ColorID
//
//  Created by Nhut Le on 5/30/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class NameDisplay: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let height = originalSize.height + 12
        layer.masksToBounds = true
        return CGSize(width: originalSize.width + 16, height: height)
    }
}
