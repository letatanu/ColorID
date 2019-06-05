//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
class ViewController: UIViewController, FrameExtractorDelegate {
     var sliderSize: UISlider {
        let slider = UISlider()
        slider.transform  = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        slider.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: self.view.bounds.height/3) )
        
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .black
        
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.setValue(Float(100-200*self.sizeOfCenterPoint/Double(self.cameraViewFrame.size.width)), animated: false)
        slider.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        return slider
    }

    var button: UIButton {
        let button = UIButton(type: .custom)
        button.sizeToFit()
        button.backgroundColor = .init(white: 1, alpha: 0.5)
        button.frame = CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: self.view.bounds.width/10, height: self.view.bounds.width/10))
        button.layer.cornerRadius = 0.3 * button.bounds.size.width
        button.clipsToBounds = true
        // set background for normal state
        let image = UIImage(named: "hamburger_button")!
        button.setBackgroundImage(image, for: .normal)
        //set background for pressed state
        let img = UIImage(named: "exit_icon")
        button.setBackgroundImage(img, for: .selected)
        button.autoresizingMask = []
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }
    
    @IBOutlet weak var colorCode: UILabel! {
        didSet {
            colorCode.adjustsFontSizeToFitWidth = true
        }
    }
    fileprivate var bottomView : BottomView!
//    @IBOutlet weak var ColorView: UIView!
//    @IBOutlet weak var ColorNameView: ColorInfoDisplay!
    var camera: Camera!
    fileprivate var angle: Double!
    var sizeOfCenterPoint = 10.0
    var lineWidth = 4
    override var shouldAutorotate: Bool {
        return false
    }
    var cameraViewFrame:  CGRect  {
        return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func layout() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bottomView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/7)
        ]
        NSLayoutConstraint.activate(constraints)
        bottomView.layer.cornerRadius = 0.05*bottomView.bounds.width
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = Camera(frame: cameraViewFrame, sizeOfCenterPoint: Int(self.sizeOfCenterPoint))
        camera.delegate = self
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(deviceDidRotate),
//            name: UIDevice.orientationDidChangeNotification,
//            object: nil
//        )
        if let cameraLayer = camera.videoPreviewLayer {
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.view.addGestureRecognizer(longTapRecognizer)
            self.view.layer.addSublayer(cameraLayer)
        }
        self.view.addSubview(button)
        bottomView = BottomView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        self.view.addSubview(bottomView)
        layout()
        camera.videoPreviewLayer?.frame = cameraViewFrame
    }
    
    fileprivate var count: Int = 0
    fileprivate final let threshold = 15
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    
//    fileprivate func compare2Images(color1: UIColor, color2: UIColor) -> Bool {
//        let totalColor1 = color1.redValue + color1.greenValue + color1.blueValue
//        let totalColor2 = color2.redValue + color2.greenValue + color2.blueValue
//        let compr = fabs(totalColor1 - totalColor2)
//        if  compr < 0.005 {
//            return true
//        }
//        return false
//    }
    func captured(image: UIImage) {
        if isInitialized {
            count += 1
            if count >= threshold {
//                let currentColor = image.averageColor!
//                let lastColor = lastImage.averageColor!
                lastImage = image
//                if !compare2Images(color1: currentColor, color2: lastColor) {
                    if  let color = image.mostDominantColor(inNumberOfCluster: 13) {
                        bottomView.color = color
//                    }
                    count = 0
                }
            }
        }
        else {
            let color_ = image.mostDominantColor(inNumberOfCluster: 5)
            lastImage = image
            isInitialized = true
            bottomView.color = color_!
        }
    }
    
    //    override func viewDidLayoutSubviews() {
    //        self.camera.videoPreviewLayer?.frame =  self.CameraView.bounds
    ////        self.camera.videoPreviewLayer?.frame =  self.view.bounds
    //
    //    }
//    @objc func deviceDidRotate() {
//        self.angle = 0.0
//        switch UIDevice.current.orientation {
//        case .landscapeLeft:
//            angle = .pi/2;
//            break;
//        case .landscapeRight:
//            angle = -.pi/2;
//            break;
//        default:
//            break;
//        }
//        UIView.animate(withDuration: 0.3, animations: {
//            //            self.ColorNameView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.ColorView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.LocalizationView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
//            //            self.LocalizationView.frame.size = CGSize(width: self.LocalizationView.bounds.height, height: self.LocalizationView.bounds.width)
//        })
//    }
    
    
    
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
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let loc = touch.location(in: self.view)
//            if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
//                self.camera.center = loc
//                self.camera.centerPointRec.removeFromSuperlayer()
//                self.camera.centerPointRec.removeAllAnimations()
//                self.camera.centerPointRec = self.camera.recCenter(radius: CGFloat(self.sizeOfCenterPoint), lineWidth: CGFloat(self.lineWidth))
//                self.camera.videoPreviewLayer?.addSublayer(self.camera.centerPointRec)
//                count = threshold + 1
//
//            }
//            else {
//                print("Error")
//            }
//        }
//    }
    
     @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
//            print("Duck! (location: \(recognizer.location(in: nil))")
            let loc = recognizer.location(in: nil)
            if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
                self.camera.center = loc
                self.camera.centerPointRec.removeFromSuperlayer()
                self.camera.centerPointRec.removeAllAnimations()
                self.camera.centerPointRec = self.camera.recCenter(radius: CGFloat(self.sizeOfCenterPoint), lineWidth: CGFloat(self.lineWidth))
                self.camera.videoPreviewLayer?.addSublayer(self.camera.centerPointRec)
                count = threshold + 1
                
            }
            else {
                print("Error")
            }
        }
    }
    
    
}

