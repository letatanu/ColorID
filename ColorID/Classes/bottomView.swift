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
    fileprivate let seperateBar: UILabel = {
        let tmp = UILabel()
        tmp.backgroundColor = .black
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
        seperateBar.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            // constrainting color display label
            colorDisplay.bottomAnchor.constraint(equalTo: bottomAnchor , constant: CGFloat(-5)),
            colorDisplay.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(5)),
            colorDisplay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(5)),
            colorDisplay.widthAnchor.constraint(equalToConstant: self.bounds.width/4),
            
            // put a line between color and labels
            seperateBar.bottomAnchor.constraint(equalTo: bottomAnchor , constant: CGFloat(-10)),
            seperateBar.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            seperateBar.leadingAnchor.constraint(equalTo: colorDisplay.trailingAnchor, constant: CGFloat(8)),
            seperateBar.widthAnchor.constraint(equalToConstant: CGFloat(1)),

            
            // constrainting  color family showing label
            colorFamily.heightAnchor.constraint(lessThanOrEqualToConstant: self.bounds.height/CGFloat(2)),
            colorFamily.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            colorFamily.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
            colorFamily.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(8)),
            
            // constrainting color name showing label
            colorName.topAnchor.constraint(equalTo: colorFamily.bottomAnchor, constant: CGFloat(5)),
            colorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
            colorName.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height/CGFloat(2)),
            colorName.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(8)),
        ]
        NSLayoutConstraint.activate(constraints)
        colorDisplay.layer.cornerRadius = 0.4*bounds.height
        colorDisplay.clipsToBounds = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius:0.05*self.bounds.width)
    }
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        backgroundColor = .init(white: 1, alpha: 0.9)
        addSubview(colorName)
        addSubview(colorFamily)
        addSubview(colorDisplay)
        addSubview(seperateBar)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
