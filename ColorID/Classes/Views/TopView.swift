//
//  bottomView.swift
//  ColorID
//
//  Created by Nhut Le on 6/1/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class TopView: UIView {
  
    fileprivate let palleteView : PaletteImageView = {
        let tmp = PaletteImageView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewLayout.init())
        return tmp
    }()
    
    //Test if the view is expanded
    fileprivate let isExpanded = false
    
    fileprivate var colorFamily : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 40)
        tmp.textColor = .white
        tmp.backgroundColor = .clear
        tmp.adjustsFontSizeToFitWidth = true
        return tmp
    }()
    
    fileprivate let seperateBar: UILabel = {
        let tmp = UILabel()
        tmp.backgroundColor = .white
        return tmp
    }()
    
    fileprivate var colorName : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 20, weight: .light)
        tmp.textColor = .white
        tmp.backgroundColor = .clear
        tmp.adjustsFontSizeToFitWidth = true
        return tmp
    }()
    
    var colorDisplay : UILabel = {
        let tmp = UILabel()
        tmp.backgroundColor = .clear
        tmp.layer.borderColor = UIColor.white.cgColor
        tmp.layer.borderWidth = 1
        return tmp
    }()
    
    var color: UIColor {
        didSet {
            let colorNameText = NSMutableAttributedString(string: "Nhóm " + color.family(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)])
            colorNameText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.brown, range: NSRange(location:0,length:4))

            colorName.attributedText = colorNameText
            let colorFamilyText = NSMutableAttributedString(string:color.name(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: .light)])
//            colorFamilyText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location:0,length:4))
            colorFamily.attributedText = colorFamilyText
            
            colorDisplay.backgroundColor = color
        }
    }
   
    func layout() {
        colorDisplay.translatesAutoresizingMaskIntoConstraints = false
        colorFamily.translatesAutoresizingMaskIntoConstraints = false
        colorName.translatesAutoresizingMaskIntoConstraints = false
        seperateBar.translatesAutoresizingMaskIntoConstraints = false
        palleteView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            // constrainting color display label
            colorDisplay.heightAnchor.constraint(equalToConstant: self.bounds.height/3*2),
            colorDisplay.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorDisplay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(10)),
            colorDisplay.widthAnchor.constraint(equalToConstant: self.bounds.height/3*2),
            
            // put a line between color and labels
            seperateBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            seperateBar.heightAnchor.constraint(equalToConstant: self.bounds.height/3*2 + 3),
            seperateBar.leadingAnchor.constraint(equalTo: colorDisplay.trailingAnchor, constant: CGFloat(10)),
            seperateBar.widthAnchor.constraint(equalToConstant: CGFloat(1)),

            
            // constrainting  color family showing label
            colorFamily.heightAnchor.constraint(lessThanOrEqualToConstant: self.bounds.height/CGFloat(3)),
            colorFamily.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            colorFamily.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
            colorFamily.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(10)),
            
            // constrainting color name showing label
            colorName.topAnchor.constraint(equalTo: colorFamily.bottomAnchor, constant: CGFloat(5)),
            colorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
//            colorName.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height/CGFloat(2)),
            colorName.bottomAnchor.constraint(equalTo: palleteView.topAnchor, constant: 5),
            colorName.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(10)),
            
            // pallete bottom view
            palleteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            palleteView.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor),
            palleteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            palleteView.heightAnchor.constraint(equalToConstant: self.bounds.height/3)
        ]
        NSLayoutConstraint.activate(constraints)
        colorDisplay.clipsToBounds = true
        colorDisplay.layer.cornerRadius = self.bounds.height/6*2
        self.superview?.bringSubviewToFront(self)
    }
    
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 1)
        addSubview(colorName)
        addSubview(colorFamily)
        addSubview(colorDisplay)
        addSubview(seperateBar)
        addSubview(palleteView)
        // adding shadow for the view
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
