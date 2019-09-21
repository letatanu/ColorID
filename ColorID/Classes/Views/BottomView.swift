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

// Mark: Delegate Protocol of Bottom View

@objc protocol BottomViewDelegate: class {
    func captureButtonPressed()
    func imagePickerButtonPressed()
    func circleSizeButtonPressed()
}


final class BottomView: UIView {
    fileprivate var captureButton: UIButton = {
        let tmp = UIButton()
        //        tmp.setImage(UIImage(named: "capture"), for: .normal)
        tmp.setTitle("Capture", for: .normal)
        tmp.addTarget(self, action: #selector(captureButtonPressed), for: .touchUpInside)
        return tmp
    }()
    var delegate: BottomViewDelegate?
    
    
    fileprivate var libraryButton: UIButton = {
        let tmp = UIButton()
        //        tmp.backgroundColor = .white
        tmp.setTitle("library", for: .normal)
        tmp.addTarget(self, action: #selector(imagePickerButtonPressed), for: .touchUpInside)
        return tmp
    }()
    
    
    fileprivate var settingButton: UIButton = {
        let tmp = UIButton()
        //        tmp.setImage(UIImage(named: "capture"), for: .normal)
        tmp.setTitle("setting", for: .normal)
        return tmp
    }()
    
     var sizeCenterWheelButton : UIButton = {
        let tmp = UIButton()
        //        tmp.backgroundColor = .black
        tmp.addTarget(self, action: #selector(sizeButtonPressed), for: .touchUpInside)
        tmp.setTitle("size", for: .normal)
        return tmp
    }()
    
    
    //    var button: UIButton = {
    //        let button = UIButton(type: .custom)
    //        button.sizeToFit()
    //        button.backgroundColor = .init(white: 0, alpha: 0.5)
    ////        button.frame = CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: self.view.bounds.width/10, height: self.view.bounds.width/10))
    //        button.layer.cornerRadius = 0.3 * button.bounds.size.width
    //        button.clipsToBounds = true
    //        // set background for normal state
    //        let image = UIImage(named: "hamburger_button")!
    //        button.setBackgroundImage(image, for: .normal)
    //        //set background for pressed state
    //        let img = UIImage(named: "exit_icon")
    //        button.setBackgroundImage(img, for: .selected)
    //        button.autoresizingMask = []
    //        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    //
    //        button.layer.shadowOpacity = 1
    //        button.layer.shadowColor = UIColor.black.cgColor
    //        button.layer.shadowRadius = 1
    //        button.layer.shadowOffset = .zero
    //        return button
    //    }()
    
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
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 1)
        addSubview(captureButton)
        addSubview(libraryButton)
        addSubview(settingButton)
        addSubview(sizeCenterWheelButton)
        
        layout()    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Mark: Events
extension BottomView {
   
    @objc fileprivate func sizeButtonPressed() {
        self.delegate?.circleSizeButtonPressed()
    }
    
    @objc fileprivate func captureButtonPressed() {
        self.delegate?.captureButtonPressed()
        self.superview?.bringSubviewToFront(self)
    }
    
    @objc fileprivate func imagePickerButtonPressed() {
        self.delegate?.imagePickerButtonPressed()
        self.superview?.bringSubviewToFront(self)
    }
}

