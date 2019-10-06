//
//  DetailColorCell.swift
//  ColorID
//
//  Created by Nhut Le on 9/21/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class DetailColorCell: UITableViewCell {
    
    let title = UILabel()
    let code = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(title)
        addSubview(code)
        
    }
    
    fileprivate func layout() {
        title.translatesAutoresizingMaskIntoConstraints = false
        code.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            code.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
