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
            let r = NSAttributedString(string: "\(Int(self.color.redValue))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            code = "\(Int(self.color.redValue*255))" + " \(Int(self.color.greenValue*255))" + " \(Int(self.color.blueValue*255))"
        case 1:
            title = "CMYK"
            code = "\(round(self.color.cmyk.cyan*1000)/1000)" + " \(round(self.color.cmyk.magneta*1000)/1000)" + " \(round(self.color.cmyk.yellow*1000)/1000)" + " \(round(self.color.cmyk.key*1000)/1000)"
        case 2:
            title = "HSL"
            code =  "\(round(self.color.hsl.hue*1000)/1000)" + " \(round(self.color.hsl.sarturation*1000)/1000)" + " \(round(self.color.hsl.lightness*1000)/1000)"

        case 3:
            title = "HSV"
            code = "\(round(self.color.hsv.hue*1000)/1000)" + " \(round(self.color.hsv.sarturation*1000)/1000)" + " \(round(self.color.hsv.value*1000)/1000)"
        default:
            title = "HEX"
            code = self.color.hexValue
            
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

