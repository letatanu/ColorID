//
//  ColorViewPopup.swift
//  ColorID
//
//  Created by Nhut Le on 6/26/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import UIKit

final class ColorDetailPopupView: UITableViewController {
    var color: UIColor {
        didSet {
            
        }
    }
    
    fileprivate let cmykLabel = UILabel()
    fileprivate let hslLabel = UILabel()
    fileprivate let hsvLabel = UILabel()
    fileprivate let LabLabel = UILabel()
    override convenience init(style: UITableView.Style) {
        self.init(style: style)
        color = UIColor()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
