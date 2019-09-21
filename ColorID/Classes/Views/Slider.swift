//
//  Slider.swift
//  ColorID
//
//  Created by Nhut Le on 9/21/19.
//  Copyright © 2019 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

protocol SliderContainerDelegate: class {
    func sliderValueChanged(value: Float)
}

final class SliderContainer: UIView {
    
    weak var delegate: SliderContainerDelegate?
    
    fileprivate var slider : UISlider = {
        let slider = UISlider()
        slider.transform  = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .black
        
        slider.maximumValue = 100
        slider.minimumValue = 0
    slider.setValue(Float(100-200*NumericalData.shared().defaultSizeOfCircle/UIScreen.main.bounds.width), animated: false)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    fileprivate func layout() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.widthAnchor.constraint(equalTo: heightAnchor),
            slider.heightAnchor.constraint(equalTo: widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 1, alpha: 0.7)
        layer.cornerRadius = bounds.width*0.1
        self.addSubview(slider)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SliderContainer {
    @objc func sliderValueChanged() {
        self.delegate?.sliderValueChanged(value: self.slider.value)
    }
}
