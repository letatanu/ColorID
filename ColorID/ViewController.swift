//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
class ViewController: UIViewController{
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
    
    // Displaying the colorCode
    @IBOutlet weak var colorCode: UILabel! {
        didSet {
            colorCode.adjustsFontSizeToFitWidth = true
        } 
    }
    fileprivate var sliderContainer: SliderContainer = {
        let tmp = SliderContainer(frame: CGRect(x: 0, y: 0, width: 25, height: UIScreen.main.bounds.height/4))
        tmp.backgroundColor = .white
        return tmp
    }()
    
    fileprivate var count: Int = 0
    fileprivate final let threshold = 10
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    
    fileprivate var bottomView: BottomView!
    fileprivate var topView : TopView!
    
    
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
        self.camera = Camera(frame: cameraViewFrame, sizeOfCenterPoint: Int(self.sizeOfCenterPoint))
        self.camera.delegate = self
        
        
        //        self.view.addSubview(button)
        topView = TopView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        self.view.addSubview(topView)
        //
        bottomView = BottomView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        bottomView.delegate = self
        
        self.view.addSubview(bottomView)
        layout()
        //
        self.addingCameraLayer()
        cameraInitialized = true
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            let loc = recognizer.location(in: nil)
            if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
                self.centerCircle.changeStatus(newLocation: loc, newLineWidth: nil, newRadius: nil)
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
    
    fileprivate var captureButtonSelected: Bool = true
    fileprivate var cameraInitialized: Bool = false
}
// Mark: Events
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.sliderContainer) else { return }
        if !self.sliderContainer.frame.contains(location) {
            self.sliderContainer.removeFromSuperview()
        }
    }
    fileprivate func addingCameraLayer () {
        guard (!captureButtonSelected || !cameraInitialized) else {return}
        print("Camera Layer")
        if self.imagePickerView.superview != nil {
            self.imagePickerView.removeFromSuperview()
        }
        self.camera.videoPreviewLayer?.frame = self.view.frame
        self.camera.captureSession.startRunning()
        self.view.layer.addSublayer(self.camera.videoPreviewLayer!)

        if let cameraLayer = self.camera.videoPreviewLayer {
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.view.addGestureRecognizer(longTapRecognizer)
            self.view.layer.addSublayer(cameraLayer)
        }
        if let camera_ = self.camera {
            self.centerCircle = CirclePoint(presentationLayer: (camera_.videoPreviewLayer)!, centerLocation: NumericalData.shared().centerPoint, radius: NumericalData.shared().defaultSizeOfCircle)
        }
        self.view.bringSubviewToFront(self.topView)
        self.view.bringSubviewToFront(self.bottomView)
    }
    
    fileprivate func addingImagePickerView () {
        guard !captureButtonSelected else {return}
        let imageFrame = self.view.frame
        self.imagePickerView.frame = imageFrame
        self.imagePickerView.image = self.pickedImage
        self.view.addSubview(self.imagePickerView)
        
        self.centerCircle.removeAll()
        self.centerCircle = CirclePoint(presentationLayer: self.imagePickerView.layer, centerLocation: NumericalData.shared().centerPoint, radius: NumericalData.shared().defaultSizeOfCircle)
        
        
        // testing imageview
        //        self.view.addSubview(testImgView)
        
        if camera.captureSession.isRunning {
            camera.captureSession.stopRunning()
            camera.videoPreviewLayer?.removeFromSuperlayer()
        }
        self.view.bringSubviewToFront(self.topView)
        self.view.bringSubviewToFront(self.bottomView)
    }
}
// Mark: Image Picker Delegate
extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let pickedImage_ = image else {return}
        captureButtonSelected = false
        self.pickedImage = pickedImage_
        if (pickedImage_.size.width > self.imagePickerView.bounds.width || pickedImage_.size.height > self.imagePickerView.bounds.height) {
            self.imagePickerView.contentMode = .scaleAspectFit
        }
        
        self.addingImagePickerView()
        guard let im = self.centerCircle.imageInCircle(orginalImage: pickedImage_, circlePoint: self.centerCircle, actualLocation: nil) else {return}
        let dColor = im.mostDominantColor(inNumberOfCluster: 15)
        topView.color = dColor!
        
    }
    
}
// Mark: Bottom View Delegate
extension ViewController: BottomViewDelegate {
    
    func circleSizeButtonPressed() {
        if self.sliderContainer.superview != nil {
            self.sliderContainer.removeFromSuperview()
        } else {
            self.sliderContainer.delegate = self
            self.view.addSubview(sliderContainer)
            
            sliderContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                sliderContainer.centerXAnchor.constraint(equalTo: self.bottomView.sizeCenterWheelButton.centerXAnchor),
                sliderContainer.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10),
                sliderContainer.widthAnchor.constraint(equalToConstant: 25),
                sliderContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    
    func captureButtonPressed() {
        print("Capture Button Pressed")
        self.addingCameraLayer()
        captureButtonSelected = true
        if self.sliderContainer.superview != nil {
            self.sliderContainer.removeFromSuperview()
        }
    }
    
    func imagePickerButtonPressed() {
        self.imagePicker.present(from: self.view)
        if self.sliderContainer.superview != nil {
            self.sliderContainer.removeFromSuperview()
        }
    }
    
    
}
// Mark: Frame Extractor Delegate
extension ViewController: FrameExtractorDelegate {
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
    
}

extension ViewController: SliderContainerDelegate {
    func sliderValueChanged(value: Float) {
        self.sizeOfCenterPoint = CGFloat(value/100)*min(self.view.bounds.height,self.view.bounds.width)
        self.centerCircle.changeStatus(newLocation: nil, newLineWidth: nil, newRadius: self.sizeOfCenterPoint)
        
    }
    
    
}
