//
//  bottomView.swift
//  ColorID
//
//  Created by Nhut Le on 6/1/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class BottomView: UIView {
    fileprivate var colorFamily : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 34)
        tmp.textColor = .black
        tmp.backgroundColor = .clear
        tmp.adjustsFontSizeToFitWidth = true
        return tmp
    }()
    
    fileprivate var colorName : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 17, weight: .light)
        tmp.textColor = .black
        tmp.backgroundColor = .clear
        tmp.adjustsFontSizeToFitWidth = true
        return tmp
    }()
    
    fileprivate var colorDisplay : UILabel = {
        let tmp = UILabel()
        tmp.backgroundColor = .clear
        return tmp
    }()
    
    var color: UIColor {
        didSet {
            colorName.text = color.name()
            colorFamily.text = color.family()
            colorDisplay.backgroundColor = color
        }
    }
   
    func layout() {
        colorDisplay.translatesAutoresizingMaskIntoConstraints = false
        colorFamily.translatesAutoresizingMaskIntoConstraints = false
        colorName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            colorFamily.heightAnchor.constraint(lessThanOrEqualToConstant: self.bounds.height/CGFloat(2)),
            colorFamily.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            colorFamily.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(10)),
            colorFamily.trailingAnchor.constraint(equalTo: colorDisplay.leadingAnchor),
//
            colorName.topAnchor.constraint(equalTo: colorFamily.bottomAnchor, constant: CGFloat(5)),
            colorName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(10)),
            colorName.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height/CGFloat(2)),

            colorDisplay.bottomAnchor.constraint(equalTo: bottomAnchor , constant: CGFloat(-5)),
            colorDisplay.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(5)),
            colorDisplay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-5)),
            colorDisplay.widthAnchor.constraint(equalToConstant: self.bounds.width/4)
        ]
        NSLayoutConstraint.activate(constraints)
        colorDisplay.layer.cornerRadius = 0.05*bounds.width
        colorDisplay.clipsToBounds = true
    }
 
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        backgroundColor = .init(white: 1, alpha: 0.9)
        addSubview(colorName)
        addSubview(colorFamily)
        addSubview(colorDisplay)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
