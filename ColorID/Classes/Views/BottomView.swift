//
//  BottomView.swift
//  ColorID
//
//  Created by Nhut Le on 7/22/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
final class BottomView: UIView {
    fileprivate var captureButton: UIButton = {
        let tmp = UIButton()
//        tmp.setImage(UIImage(named: "capture"), for: .normal)
        tmp.setTitle("Capture", for: .normal)
        return tmp
    }()
    var imagePickerPassedFromSuperView: ImagePicker!

    fileprivate var libraryButton: UIButton = {
        let tmp = UIButton()
//        tmp.backgroundColor = .white
        tmp.setTitle("library", for: .normal)

        return tmp
    }()
    
    fileprivate var settingButton: UIButton = {
        let tmp = UIButton()
//        tmp.setImage(UIImage(named: "capture"), for: .normal)
        tmp.setTitle("setting", for: .normal)
        return tmp
    }()
    
    fileprivate var sizeCenterWheelButton : UIButton = {
        let tmp = UIButton()
//        tmp.backgroundColor = .black
        tmp.setTitle("size", for: .normal)
        return tmp
    }()
    
    fileprivate func layout() {
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        sizeCenterWheelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            libraryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            libraryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  CGFloat(10)),
            libraryButton.widthAnchor.constraint(equalToConstant: min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            libraryButton.heightAnchor.constraint(equalToConstant: min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            
            
            captureButton.leadingAnchor.constraint(equalTo: libraryButton.trailingAnchor, constant: CGFloat(10)),
            captureButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            captureButton.heightAnchor.constraint(equalToConstant:  min(self.frame.width * 0.16,  self.frame.height * 0.7)),
            captureButton.widthAnchor.constraint(equalToConstant:  min(self.frame.width * 0.16,  self.frame.height * 0.7)),
            
            sizeCenterWheelButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: CGFloat(-10)),
            sizeCenterWheelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sizeCenterWheelButton.heightAnchor.constraint(equalToConstant:  min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            sizeCenterWheelButton.widthAnchor.constraint(equalToConstant: min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            sizeCenterWheelButton.leadingAnchor.constraint(greaterThanOrEqualTo: captureButton.trailingAnchor, constant: 10),
            
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-10)),
            settingButton.widthAnchor.constraint(equalToConstant: min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            settingButton.heightAnchor.constraint(equalToConstant: min(self.frame.width * 0.15,  self.frame.height * 0.7)),
            settingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            

            
        ]
        NSLayoutConstraint.activate(constraints)
        self.superview?.bringSubviewToFront(self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 1)
        addSubview(captureButton)
        addSubview(libraryButton)
        addSubview(settingButton)
        addSubview(sizeCenterWheelButton)
        self.libraryButton.addTarget(self, action: #selector(libraryButtonPressed), for: .touchUpInside)
        layout()    
    }
    // library selected
    @objc fileprivate func libraryButtonPressed() {
        imagePickerPassedFromSuperView.present(from: self.superview!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
