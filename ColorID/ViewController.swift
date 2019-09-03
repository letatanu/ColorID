//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
final class ViewController: UIViewController, FrameExtractorDelegate, UIImagePickerControllerDelegate {
//    This is for image picker
    fileprivate let imagePickerView: UIImageView = {
        let tmp = UIImageView()
        return tmp
    }()
    
    fileprivate var imagePicker : UIImagePickerController = {
        let tmp = UIImagePickerController()
        return tmp
    }()
////////////////

    
    // It is used for adjusting the size of the color detection circle
    var sliderSize: UISlider {
        let slider = UISlider()
        slider.transform  = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        slider.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: NumericalData.getInstance().screenHeight/3) )
        
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .black
        
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.setValue(Float(100-200*self.sizeOfCenterPoint/Double(self.cameraViewFrame.size.width)), animated: false)
        slider.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        return slider
    }
    
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
    // Displaying the colorCode
    @IBOutlet weak var colorCode: UILabel! {
        didSet {
            colorCode.adjustsFontSizeToFitWidth = true
        }
    }
    
    fileprivate var bottomView: BottomView!
    fileprivate var topView : TopView!
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
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        //        roundCorners(corners: [.topLeft, .topRight], radius:0.05*self.bounds.width)
    //        topView.colorDisplay.layer.cornerRadius = topView.colorDisplay.bounds.height*0.5
    //    }
    
    // setting the layout of subviews
    fileprivate func layout() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        //        button.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            topView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/7),
            
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/7),
            
            ]
        NSLayoutConstraint.activate(constraints)
        topView.layer.cornerRadius = 0.05*topView.bounds.width
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = Camera(frame: cameraViewFrame, sizeOfCenterPoint: Int(self.sizeOfCenterPoint))
        camera.delegate = self
        
        if let cameraLayer = camera.videoPreviewLayer {
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.view.addGestureRecognizer(longTapRecognizer)
            self.view.layer.addSublayer(cameraLayer)
        }
        //        self.view.addSubview(button)
        topView = TopView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        self.view.addSubview(topView)
        
        bottomView = BottomView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        self.view.addSubview(bottomView)
        layout()
        camera.videoPreviewLayer?.frame = cameraViewFrame
    }
    
    fileprivate var count: Int = 0
    fileprivate final let threshold = 15
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    
    func captured(image: UIImage) {
        if isInitialized {
            count += 1
            if count >= threshold {
                lastImage = image
                if  let color = image.mostDominantColor(inNumberOfCluster: 13) {
                    topView.color = color
                    //                    }
                    count = 0
                }
            }
        }
        else {
            let color_ = image.mostDominantColor(inNumberOfCluster: 5)
            lastImage = image
            isInitialized = true
            topView.color = color_!
        }
    }
    
    
    @IBOutlet weak var selectedLanguage: UIPickerView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
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

