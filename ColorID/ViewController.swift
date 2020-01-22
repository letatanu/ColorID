//
//  ViewController.swift
//  ColorID
//
//  Created by Le Nhut on 6/21/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import UIKit
class ViewController: UIViewController{
    // MARK: Image Picker Button
    fileprivate let imagePickerView: UIImageView = {
        let tmp = UIImageView()
        tmp.contentMode = UIView.ContentMode.center
        return tmp
    }()
    
    /// Testing variables
        fileprivate var imageTest: UIImageView!
    ////////
    
    
    // MARK: Center circle
    fileprivate var centerCircle : CirclePoint!
    fileprivate var imagePicker : ImagePicker!
    fileprivate var pickedImage: UIImage!
    ////////
    ///
    //
    /*
     MARK: Variables for frame exactor Class
     */
    fileprivate var count: Int = 0
    fileprivate final let threshold = 15
    fileprivate var stoppedCameraProcess: Bool = false
    fileprivate var calculatingProcess: Bool = true
    
    /*
     
     */
    fileprivate var isInitialized: Bool = false
    fileprivate var lastImage = UIImage()
    fileprivate var currentColor = UIColor()
    ////////
    fileprivate var bottomView: BottomView!
    fileprivate var topView : TopView!
    
    /// flags
    var camera: Camera!
    //    fileprivate var angle: Double!
    
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
    
    // MARK: Layout subviews
    fileprivate func layout() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            topView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/7),
            
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/7),
            
        ]
        NSLayoutConstraint.activate(constraints)
        topView.layer.cornerRadius = 0.01*topView.bounds.width
        
    }
    
    fileprivate var sizeOfCenterPoint: CGFloat = NumericalData.shared().defaultSizeOfCircle
    
    fileprivate var sliderContainer: SliderContainer = {
        let initValue = Float(NumericalData.shared().defaultSizeOfCircle/min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)*100)
        let tmp = SliderContainer(frame: CGRect(x: 0, y: 0, width: 25, height: UIScreen.main.bounds.height/4), initialValue: initValue)
        tmp.backgroundColor = .white
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        /*
         MARK: Initializing Views
         */
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.camera = Camera(frame: cameraViewFrame)
        topView = TopView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        bottomView = BottomView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height/7)))
        
        //**************////
        /*
         MARK: Set delegate for each subview
         */
        self.camera.delegate = self
        topView.delegate = self
        bottomView.delegate = self
        
        //**************////
        
        
        
        /*
         MARK: Adding subviews to the main View
         */
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.addingCameraLayer()
        
        
        // Layout
        layout()
        
        
        
        
    }
    
   
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if self.captureButtonSelected {
            self.camera.captureSession.startRunning()
        }
    }
    fileprivate var captureButtonSelected: Bool = true
    fileprivate var cameraInitialized: Bool = false
    
}

// MARK: Gesture events
extension ViewController {
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        let touch = touches.first
    //        guard let location = touch?.location(in: self.view) else { return }
    //        if !self.sliderContainer.frame.contains(location) {
    //            if self.sliderContainer.superview != nil {
    //                self.sliderContainer.removeFromSuperview()
    //                return
    //            }
    //        }
    //
    //        let loc = location
    //        if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
    //            self.centerCircle.changeStatus(newLocation: loc, newLineWidth: nil, newRadius: nil)
    //
    //            if !camera.captureSession.isRunning {
    //                // rendering the image picker view to take the true location of the center cirle
    //                let renderer = UIGraphicsImageRenderer(size: self.imagePickerView.bounds.size)
    //                let image = renderer.image { ctx in
    //                    self.imagePickerView.drawHierarchy(in: self.imagePickerView.bounds, afterScreenUpdates: false)
    //                }
    //
    //                guard let im = self.centerCircle.imageInCircle(orginalImage: image, actualLocation: nil) else {return}
    //
    //                if let dColor = im.mostDominantColor(inNumberOfCluster: 15) {
    //                    topView.color = dColor
    //                }
    //            }
    //        }
    //        else {
    //            print("Error")
    //        }
    //    }
    // MARK: Pich gesture
    @IBAction func didPinch(_ sender: Any) {
           let gesture = sender as! UIPinchGestureRecognizer
           if gesture.state == .began || gesture.state == .changed {
               self.calculatingProcess = false
               let scale = gesture.scale
               let newRad = min(self.view.bounds.width/2,self.view.bounds.height/2, scale*self.centerCircle.getRadius())
               self.centerCircle.changeStatus(newLocation: nil, newLineWidth: nil, newRadius: newRad)
               (sender as! UIPinchGestureRecognizer).scale = 1.0
           }
           if gesture.state == .ended {
               self.calculatingProcess = true
           }
           
       }
    
    // MARK: Long Press gesture
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            let loc = recognizer.location(in: nil)
            if loc.x <= cameraViewFrame.width && loc.y <= self.cameraViewFrame.height {
                self.centerCircle.changeStatus(newLocation: loc, newLineWidth: nil, newRadius: nil)
                if !camera.captureSession.isRunning {
                    // rendering the image picker view to take the true location of the center cirle
                    let renderer = UIGraphicsImageRenderer(size: self.imagePickerView.bounds.size)
                    let image = renderer.image { ctx in
                        self.imagePickerView.drawHierarchy(in: self.imagePickerView.bounds, afterScreenUpdates: false)
                    }
                    
                    guard let im = self.centerCircle.imageInCircle(orginalImage: image, actualLocation: nil) else {return}
                    
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

// MARK: Camera Process
extension ViewController {
    
    /*
     Starting the camera process
     */
    
    @objc fileprivate func getImageScheduled() {
        self.camera.capturingPhoto {(image, error) in
            if let img = image {
                self.lastImage = img
                
                /*
                 MARK: (IMPORTANT) Need to drop the frame of the image got from capture delegate to video preview layer frame.
                 */
                
                let croppedImg = img.crop(to: ((self.camera.videoPreviewLayer?.frame.size)!))
                ///*******///////
                // Processing cropped image
                if let im = self.centerCircle.imageInCircle(orginalImage: croppedImg, actualLocation: nil)
                {
                    guard let color = im.mostDominantColor(inNumberOfCluster: 4) else{return}
                    self.currentColor = color
                    self.topView.color = color
                }
                
            }
        }
    }
    
    /*
     MARK: Adding Camera Layer and initialize it
     */
    
    fileprivate func addingCameraLayer () {
        guard (!captureButtonSelected || !cameraInitialized) else {return}
        print("Camera Layer")
        if self.imagePickerView.superview != nil {
            self.imagePickerView.removeFromSuperview()
        }
        
        // config frame for the camera preview layer
        self.camera.videoPreviewLayer?.frame = self.cameraViewFrame
        
        if !self.camera.captureSession.isRunning {
            self.camera.captureSession.startRunning()
        }
        
        self.view.layer.addSublayer(self.camera.videoPreviewLayer!)
        
        /*
         MARK: adding long tap gesture and the mark center circle to the camera preview layer
         */
        
        // adding long tap gesture to the camera preview layer
        if let cameraLayer = self.camera.videoPreviewLayer {
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.view.addGestureRecognizer(longTapRecognizer)
            self.view.layer.addSublayer(cameraLayer)
        }
        
        // adding the mark center circle
        if let camera_ = self.camera {
            self.centerCircle = CirclePoint(presentationLayer: (camera_.videoPreviewLayer)!, centerLocation: NumericalData.shared().centerPoint, radius: NumericalData.shared().defaultSizeOfCircle)
        }
        /// ------------- /////
        
        self.view.bringSubviewToFront(self.topView)
        self.view.bringSubviewToFront(self.bottomView)
    }
    
    /*
     Stop the camera process
     */
    func stopCameraProcess() {
        //        self.timer.invalidate()
        if self.camera.captureSession.isRunning {
            self.camera.captureSession.stopRunning()
        }
        
        self.stoppedCameraProcess = true
    }
}

// MARK: BOTTOM VIEW
extension ViewController {
    
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
        guard let im = self.centerCircle.imageInCircle(orginalImage: pickedImage_, actualLocation: nil) else {return}
        let dColor = im.mostDominantColor(inNumberOfCluster: 15)
        topView.color = dColor!
        
    }
    
}
//Mark: Top View delegate
extension ViewController: TopViewDelegate {
    func topViewPressed() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            viewController.color = self.currentColor
            if let navigator = self.navigationController {
                self.camera.captureSession.stopRunning()
                navigator.pushViewController(viewController, animated: true)
            }
            
        }
    }
}
// Mark: Bottom View Delegate
extension ViewController: BottomViewDelegate {
    func settingButtonPressed() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
            //            viewController.color = self.currentColor
            if let navigator = self.navigationController {
                self.camera.captureSession.stopRunning()
                navigator.pushViewController(viewController, animated: true)
            }
            
        }
    }
    
    
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
            self.count = 0
        }
    }
    
    func captureButtonPressed() {
        self.addingCameraLayer()
        captureButtonSelected = true
        if self.sliderContainer.superview != nil {
            self.sliderContainer.removeFromSuperview()
        }
        self.camera.capturingPhoto {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.lastImage = image
            self.imageTest = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: 200, height: 200)))
            self.imageTest.contentMode = .scaleAspectFit
            self.view.addSubview(self.imageTest)
            self.imageTest.image = image
        
        }
    }
    
    func imagePickerButtonPressed() {
        self.imagePicker.present(from: self.view)
        if self.sliderContainer.superview != nil {
            self.sliderContainer.removeFromSuperview()
        }
    }
    
    
}

extension ViewController: SliderContainerDelegate {
    
    
    func sliderValueChanged(value: Float) {
        self.calculatingProcess = false
        self.sizeOfCenterPoint = CGFloat(value/100)*min(self.view.bounds.height/2,self.view.bounds.width/2)
        self.centerCircle.changeStatus(newLocation: nil, newLineWidth: nil, newRadius: self.sizeOfCenterPoint)
        self.calculatingProcess = true
    }
    
    
}
// MARK: Received frame sequencely from camera delegate and process

extension ViewController: FrameExtractorDelegate {
    func returnedImage(image: UIImage) {
        if self.count > self.threshold && self.calculatingProcess {
            self.count = 0
            if let img = self.centerCircle.imageInCircle(orginalImage: image, actualLocation: nil) {
                
                let resizedImage = img.resized(toWidth: NumericalData.shared().defaultSizeOfCircle)
                try self.topView.color = resizedImage!.mostDominantColor(inNumberOfCluster: 12)!
            }
        }
        self.count += 1
    }
    
    
}
