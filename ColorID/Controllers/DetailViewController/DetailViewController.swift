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
        tableView.register(DetailColorCell.self, forCellReuseIdentifier: "DetailColorCell")
    }
    override func viewDidLoad() {
        self.config()
        
    }
    
}
// data source
extension DetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
  
    
    // customize cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailColorCell", for: indexPath) as! DetailColorCell
        var title = ""
        var code = ""
        switch indexPath.row {
        case 0:
            title = "RGB"
            code = "0xxx"
        case 1:
            title = "CMYK"
            code = "0xsdsfds"
        case 2:
            title = "HSB"
            code = "0xsdsfds"
        case 3:
            title = "HSV"
            code = "0xsdsfds"
        default:
            title = "HEX"
            code = "0xsdsfds"
            
        }
        cell.title.text = title
        cell.code.text = code
        return cell

       }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hello"
    }
    
}

