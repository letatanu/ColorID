//
//  SettingViewController.swift
//  ColorID
//
//  Created by Nhut Le on 12/27/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    
    fileprivate func config() {
        if let navigator = self.navigationController {
               navigator.isNavigationBarHidden = false
                   navigator.navigationItem.hidesBackButton = false
               }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    override func viewDidLoad() {
        self.config()
    }
}

// Data Source
extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Hello"
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Feedback"
            default:
                cell?.textLabel?.text = "Rate App"

            }
        default:
                    cell?.textLabel?.text = "Donate"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Feedback selected")
            default:
                print("Rate app selected")
            }
        default:
            print("Donate selected")
        }
    }
}
