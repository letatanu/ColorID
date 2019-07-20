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
final class PaletteImageView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var mainImage = UIImage()
    fileprivate var paletteColors : [UIColor] = {
        let tmp = [UIColor]()
        return tmp
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PaletteImageViewCell
        return cell
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.register(PaletteImageViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
