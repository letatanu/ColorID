//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
import RHSideButtons
class ViewController: UIViewController, FrameExtractorDelegate, RHSideButtonsDelegate, RHSideButtonsDataSource {
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return 1
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return RHButtonView {
            $0.bgColor = UIColor.white
        }
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("Selected index {index}")
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("Trigger Button Changed to state")
    }
    
    
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ColorNameView: ColorInfoDisplay!
    fileprivate var camera: Camera!
    fileprivate var angle: Double!
    fileprivate var sizeOfCenterPoint = 10.0
    fileprivate var lineWidth = 4
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
        
        // set up the top right floating button
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
            $0.image = UIImage(named: "trigger_img")
            $0.hasShadow = true
        }
        
        // sideButton
        let sideButtonView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        sideButtonView.delegate = self
        sideButtonView.dataSource = self

        ////////////
        
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
//        let pinch = UIGestureRecognizer(target: self, action: #selector(ZoomInOut(sender:)))
        //        self.camera.videoPreviewLayer.addGestureRecognizer(pinch)
    }
    fileprivate var count: Int = 0
    fileprivate final let threshold = 15
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    fileprivate func compare2Images(color1: UIColor, color2: UIColor) -> Bool {
        let totalColor1 = color1.redValue + color1.greenValue + color1.blueValue
        let totalColor2 = color2.redValue + color2.greenValue + color2.blueValue
        let compr = fabs(totalColor1 - totalColor2)
        if  compr < 0.005 {
            return true
        }
        return false
    }
    func captured(image: UIImage) {
        if isInitialized {
            count += 1
            if count >= threshold {
//                let currentColor = image.averageColor!
//                let lastColor = lastImage.averageColor!
                lastImage = image
//                if !compare2Images(color1: currentColor, color2: lastColor) {
                    if  let color = image.mostDominantColor(inNumberOfCluster: 15) {
                        self.ColorView.backgroundColor = color
                        self.ColorNameView.showColorInfo(color)
//                    }
                    count = 0
                }
            }
        }
        else {
            let color_ = image.mostDominantColor(inNumberOfCluster: 5)
            lastImage = image
            isInitialized = true
            self.ColorView.backgroundColor = color_
            self.ColorNameView.showColorInfo(color_!)
        }
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
//        UIView.animate(withDuration: 0.3, animations: {
//            //            self.ColorNameView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.ColorView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.LocalizationView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.LocalizationView.frame.size = CGSize(width: self.LocalizationView.bounds.height, height: self.LocalizationView.bounds.width)
//        })
    }
    
    
    
    @IBOutlet weak var selectedLanguage: UIPickerView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    @objc func ZoomInOut(sender: UIPinchGestureRecognizer) {
//        guard sender.view != nil else { return }
//        if sender.state == .began || sender.state == .changed {
//            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
//            sender.scale = 1.0
//        }
//    }
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

