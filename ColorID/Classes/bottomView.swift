//
//  bottomView.swift
//  ColorID
//
//  Created by Nhut Le on 6/1/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class BottomView: UIView {
  
    fileprivate let palleteView : PaletteImageView = {
        let tmp = PaletteImageView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewLayout.init())
        return tmp
    }()
    
    //Test if the view is expanded
    fileprivate let isExpanded = false
    
    fileprivate var colorFamily : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: 31)
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
        tmp.font = UIFont.systemFont(ofSize: 13, weight: .light)
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
        palleteView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            // constrainting color display label
            colorDisplay.heightAnchor.constraint(equalToConstant: self.bounds.height/3*2),
            colorDisplay.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(3)),
            colorDisplay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(5)),
            colorDisplay.widthAnchor.constraint(equalToConstant: self.bounds.height/3*2),
            
            // put a line between color and labels
            seperateBar.bottomAnchor.constraint(equalTo: palleteView.topAnchor , constant: 5),
            seperateBar.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            seperateBar.leadingAnchor.constraint(equalTo: colorDisplay.trailingAnchor, constant: CGFloat(8)),
            seperateBar.widthAnchor.constraint(equalToConstant: CGFloat(1)),

            
            // constrainting  color family showing label
            colorFamily.heightAnchor.constraint(lessThanOrEqualToConstant: self.bounds.height/CGFloat(3)),
            colorFamily.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)),
            colorFamily.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
            colorFamily.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(8)),
            
            // constrainting color name showing label
            colorName.topAnchor.constraint(equalTo: colorFamily.bottomAnchor, constant: CGFloat(5)),
            colorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(0)),
//            colorName.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height/CGFloat(2)),
            colorName.bottomAnchor.constraint(equalTo: palleteView.topAnchor, constant: 5),
            colorName.leadingAnchor.constraint(equalTo: seperateBar.trailingAnchor, constant: CGFloat(8)),
            
            // pallete bottom view
            palleteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            palleteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            palleteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            palleteView.heightAnchor.constraint(equalToConstant: self.bounds.height/3)
            
        ]
        NSLayoutConstraint.activate(constraints)
        colorDisplay.clipsToBounds = true
        
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        roundCorners(corners: [.topLeft, .topRight], radius:0.05*self.bounds.width)
//    }
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        backgroundColor = .init(white: 1, alpha: 0.9)
        addSubview(colorName)
        addSubview(colorFamily)
        addSubview(colorDisplay)
        addSubview(seperateBar)
        addSubview(palleteView)
        layout()
        colorDisplay.layer.cornerRadius = colorDisplay.frame.width*0.5

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
