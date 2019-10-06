//
//  DetailViewController.swift
//  ColorID
//
//  Created by Nhut Le on 9/21/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController {
    var color: UIColor!
    
    fileprivate func config() {
        if let navigator = self.navigationController {
        navigator.isNavigationBarHidden = false
            navigator.navigationItem.hidesBackButton = false
        }
    }
    override func viewDidLoad() {
        self.config()
    }
}
