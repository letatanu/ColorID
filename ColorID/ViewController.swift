//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FrameExtractorDelegate {
    
    
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ColorNameView: ColorInfoDisplay!
    var camera: Camera!
    var angle: Double!
    var sizeOfCenterPoint = 10.0
    var lineWidth = 4
    override var shouldAutorotate: Bool {
        return false
    }
    fileprivate var cameraViewFrame:  CGRect  {
        return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - self.ColorNameView.bounds.height)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = Camera(frame: cameraViewFrame, sizeOfCenterPoint: Int(self.sizeOfCenterPoint))
        camera.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDidRotate),
            name: .UIDeviceOrientationDidChange,
            object: nil
        )
        if let cameraLayer = camera.videoPreviewLayer {
            self.view.layer.addSublayer(cameraLayer)
        }
        camera.videoPreviewLayer?.frame = cameraViewFrame
        let pinch = UIGestureRecognizer(target: self, action: #selector(ZoomInOut(sender:)))
//        self.camera.videoPreviewLayer.addGestureRecognizer(pinch)
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
    
    
    @objc func ZoomInOut(sender: UIPinchGestureRecognizer) {
        guard sender.view != nil else { return }
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }
    }
    // handling event when changing center point location
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self.view)
            if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
                self.camera.center = loc
                self.camera.centerPointRec.removeFromSuperlayer()
                self.camera.centerPointRec.removeAllAnimations()
                self.camera.centerPointRec = self.camera.recCenter(radius: CGFloat(self.sizeOfCenterPoint), lineWidth: CGFloat(self.lineWidth))
                self.camera.videoPreviewLayer?.addSublayer(self.camera.centerPointRec)
                
            }
            else {
                print("Error")
            }
        }
    }


}

