//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FrameExtractorDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    @IBOutlet weak var CameraView: UIView!
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ColorNameView: ColorInfoDisplay!
    var camera: Camera!
    var angle: Double!
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        camera = Camera(frame: self.CameraView.bounds, sizeOfCenterPoint: 10)
        camera.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDidRotate),
            name: .UIDeviceOrientationDidChange,
            object: nil
        )
        if let cameraLayer = camera.videoPreviewLayer {
            self.CameraView.layer.addSublayer(cameraLayer)
        }
        camera.videoPreviewLayer?.frame = self.CameraView.bounds
    }
    
    func captured(image: UIImage) {
        let color = image.mostDominantColor(inNumberOfCluster: 5)
        self.ColorView.backgroundColor = color
        self.ColorNameView.showColorInfo(color!)
        
    }
    
//    override func viewDidLayoutSubviews() {
//        self.camera.videoPreviewLayer?.frame =  self.CameraView.bounds
////        self.camera.videoPreviewLayer?.frame =  self.view.bounds
//
//    }
    @objc func deviceDidRotate() {
        self.angle = 0.0
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            angle = .pi/2;
            break;
        case .landscapeRight:
            angle = -.pi/2;
            break;
        default:
            break;
        }
        UIView.animate(withDuration: 0.3, animations: {
//            self.ColorNameView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            self.ColorView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            self.LocalizationView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            self.LocalizationView.frame.size = CGSize(width: self.LocalizationView.bounds.height, height: self.LocalizationView.bounds.width)
            })
    }
    
    
    
    @IBOutlet weak var selectedLanguage: UIPickerView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

