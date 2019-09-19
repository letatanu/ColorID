//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
class ViewController: UIViewController, FrameExtractorDelegate{
    //    This is for image picker
    fileprivate let imagePickerView: UIImageView = {
        let tmp = UIImageView()
        tmp.contentMode = UIView.ContentMode.center
        return tmp
    }()
    // Center circle
    fileprivate var centerCircle : CirclePoint!
    fileprivate var imagePicker : ImagePicker!
    fileprivate var pickedImage: UIImage!
    // It is used for adjusting the size of the color detection circle
    //    var sliderSize: UISlider {
    //        let slider = UISlider()
    //        slider.transform  = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    //        slider.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: NumericalData.getInstance().screenHeight/3) )
    //
    //        slider.minimumTrackTintColor = .green
    //        slider.maximumTrackTintColor = .red
    //        slider.thumbTintColor = .black
    //
    //        slider.maximumValue = 100
    //        slider.minimumValue = 0
    //        slider.setValue(Float(100-200*self.sizeOfCenterPoint/Double(self.cameraViewFrame.size.width)), animated: false)
    //        slider.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
    //        return slider
    //    }
    
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
        topView.layer.cornerRadius = 0.01*topView.bounds.width
        
    }
    
    fileprivate var sizeOfCenterPoint: CGFloat = NumericalData.shared().defaultSizeOfCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        //
        bottomView = BottomView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        bottomView.imagePickerPassedFromSuperView = imagePicker
        self.view.addSubview(bottomView)
        layout()
        //
        camera.videoPreviewLayer?.frame = cameraViewFrame
        //
        if let camera_ = camera {
            self.centerCircle = CirclePoint(presentationLayer: (camera_.videoPreviewLayer)!, centerLocation: CGPoint(x: (camera_.videoPreviewLayer?.bounds.width)!*0.5, y: (camera_.videoPreviewLayer?.bounds.height)!*0.5), radius: CGFloat(10))
        }
        
    }
    
    fileprivate var count: Int = 0
    fileprivate final let threshold = 15
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    
    func captured(image: UIImage) {
        
        guard self.camera.captureSession.isRunning else {return}
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
                self.centerCircle.changeStatus(newLocation: loc, newLineWidth: nil)
                camera.circleLocation = loc
                if !camera.captureSession.isRunning {
                    
                    // rendering the image picker view to take the true location of the center cirle
                    let renderer = UIGraphicsImageRenderer(size: self.imagePickerView.bounds.size)
                    let image = renderer.image { ctx in
                        self.imagePickerView.drawHierarchy(in: self.imagePickerView.bounds, afterScreenUpdates: false)
                    }
                    
                    guard let im = self.centerCircle.imageInCircle(orginalImage: image, circlePoint: self.centerCircle, actualLocation: nil) else {return}
                    
                    if let dColor = im.mostDominantColor(inNumberOfCluster: 15) {
                        topView.color = dColor
                    }
                }
            }
            else {
                print("Error")
            }
        }
    }
}

extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let pickedImage_ = image else {return}
        self.pickedImage = pickedImage_
        if (pickedImage_.size.width > self.imagePickerView.bounds.width || pickedImage_.size.height > self.imagePickerView.bounds.height) {
            self.imagePickerView.contentMode = .scaleAspectFit
        }
        let imageFrame = self.view.frame
        self.imagePickerView.frame = imageFrame
        self.imagePickerView.image = self.pickedImage
        self.view.addSubview(self.imagePickerView)
        self.view.bringSubviewToFront(self.topView)
        self.view.bringSubviewToFront(self.bottomView)
        self.centerCircle.removeAll()
        self.centerCircle = CirclePoint(presentationLayer: self.imagePickerView.layer, centerLocation: NumericalData.shared().centerPoint, radius: NumericalData.shared().defaultSizeOfCircle)
        
        
        // testing imageview
//        self.view.addSubview(testImgView)
        
        if camera.captureSession.isRunning {
            camera.captureSession.stopRunning()
            camera.videoPreviewLayer?.removeFromSuperlayer()
        }
        
        guard let im = self.centerCircle.imageInCircle(orginalImage: pickedImage_, circlePoint: self.centerCircle, actualLocation: nil) else {return}
        let dColor = im.mostDominantColor(inNumberOfCluster: 15)
        topView.color = dColor!
        
    }
    
}
