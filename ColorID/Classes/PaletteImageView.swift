//
//  PaletteImageView.swift
//  ColorID
//
//  Created by Nhut Le on 6/29/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import ColorThiefSwift
final class PaletteImageView: UICollectionView {
    var mainImage = UIImage()
    fileprivate var paletteColors : [UIColor] = {
        let tmp = [UIColor]()
        return tmp
    }()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(PaletteImageViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
