//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FrameExtractorDelegate {
    
    
    @IBOutlet weak var CameraView: UIView!
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ColorNameView: ColorInfoDisplay!
    var camera: Camera!
    var angle: Double!
    var sizeOfCenterPoint = 10.0
    var lineWidth = 4
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        camera = Camera(frame: self.CameraView.bounds, sizeOfCenterPoint: Int(self.sizeOfCenterPoint))
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
    
    // handling event when changing center point location
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self.CameraView)
            if loc.x <= self.CameraView.bounds.width && loc.y <= self.CameraView.bounds.height {
                self.camera.center = loc
                self.camera.videoPreviewLayer?.sublayers?.last?.removeFromSuperlayer()
                let centerPointRec = self.camera.recCenter(radius: CGFloat(self.sizeOfCenterPoint), lineWidth: CGFloat(self.lineWidth))
                self.camera.videoPreviewLayer?.addSublayer(centerPointRec)
                
            }
            else {
                print("Error")
            }
        }
    }


}

