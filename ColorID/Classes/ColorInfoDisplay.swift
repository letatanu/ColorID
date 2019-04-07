//
//  ColorInfoDisplay.swift
//  ColorID
//
//  Created by Le Nhut on 8/14/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit

class ColorInfoDisplay: UIView {
    @IBOutlet weak var family: UILabel!
    @IBOutlet weak var fullName: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func showColorInfo(_ color: UIColor) {
        let name = color.name()
        let family = color.family()
        self.fullName.text = name
        self.family.text = family
    }
}
