//
//  ViewController+UIPicker.swift
//  ColorID
//
//  Created by Le Nhut on 4/3/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}
