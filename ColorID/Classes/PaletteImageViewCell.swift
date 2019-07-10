//
//  PaletteImageViewCell.swift
//  ColorID
//
//  Created by Nhut Le on 7/1/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

final class PaletteImageViewCell: UICollectionViewCell {
    fileprivate let cellID = "CellID"
    var color : UIColor {
        didSet {
            let colorName = color.name()
            let colorHex = color.hexValue
            let attributedText = NSMutableAttributedString(string: colorName+"\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
            attributedText.append(NSAttributedString(string: colorHex, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .light)]))
            colorLabel.attributedText = attributedText
            colorImage.backgroundColor = self.color
        }
    }
    fileprivate var colorLabel: UILabel = {
       let tmp = UILabel()
        tmp.lineBreakMode = .byWordWrapping
        tmp.numberOfLines = 0
        return tmp
    }()
    
    fileprivate let colorImage: UILabel = {
        let tmp = UILabel()
        return tmp
    }()
    
    func layout() {
        self.colorImage.translatesAutoresizingMaskIntoConstraints = false
        self.colorLabel.translatesAutoresizingMaskIntoConstraints = false
        let contrainst = [
            colorImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            colorImage.bottomAnchor.constraint(equalTo: colorLabel.topAnchor),
            colorImage.heightAnchor.constraint(equalToConstant: self.bounds.height*0.7),
            
            colorLabel.topAnchor.constraint(equalTo: colorImage.bottomAnchor),
            colorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    override init(frame: CGRect) {
        color = UIColor()
        super.init(frame: frame)
        self.contentView.addSubview(self.colorLabel)
        self.contentView.addSubview(self.colorImage)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
