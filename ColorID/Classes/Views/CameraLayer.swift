//
//  CameraLayer.swift
//  ColorID
//
//  Created by Le Nhut on 6/26/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
// This is the configuration of camera
// It will ask for user's permission to use func in camera

import Foundation
import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
    func returnedImage(image: UIImage)
    //    func dominantColor(color: UIColor)
}


final class Camera: NSObject {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? //render the camera view finder
    
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    // MARK: Delegate variable
    weak var delegate: FrameExtractorDelegate?
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var stillImageOutput = AVCapturePhotoOutput()
    
    // MARK: Config Camera
    private let position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.high
    let captureSession = AVCaptureSession()
    private let context = CIContext()
    
    // MARK: Storing captured image
    var capturedImage = UIImage()
    private var oldCapturedPhoto: UIImage? = nil
    private var currentCapturedPhoto: UIImage? = nil
    
    // MARK: Permission Config
    private var permissionGranted = false
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    // MARK: select rear/front camera
    private func selectCaptureDevice(positionCamera: String) -> AVCaptureDevice? {
        if positionCamera == "front" {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { return nil}
            return device
        }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else { return nil }
        return device
    }
    
    // MARK: Request permission to access camera device
    private func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    // MARK: Configure Camera Session
    private func configureSession(frame: CGRect) {
        // asking for permission
        guard permissionGranted else { return }
        
        // MARK: config video preview layer
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.frame = frame
        
        // config capture session
        captureSession.sessionPreset = self.quality
        
        //MARK: config input device
        guard let captureDevice = selectCaptureDevice(positionCamera: "back") else { return }
        do {
            try captureDevice.lockForConfiguration()
        } catch _ {
            print("failed locking device")
        }
        
        captureDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 30)
        captureDevice.unlockForConfiguration()
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        // MARK: adding input
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        
        //MARK: config output device
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        // MARK: adding output
        guard captureSession.canAddOutput(stillImageOutput) else { return }
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(stillImageOutput)
        captureSession.addOutput(videoOutput)
        
        // MARK: Config camera orientation
        guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
        
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = position == .front
        
    }
    
    init(frame: CGRect) {
        super.init()
        checkPermission()
        
        self.configureSession(frame: frame)
        if !self.captureSession.isRunning {
            self.captureSession.startRunning()
        }
    }
    
    func updatePreviewLayer(size: CGSize) {
        self.videoPreviewLayer?.frame.size = size
    }
    
}
// MARK: Camera delegate
extension Camera: AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: Sample buffer to UIImage
    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let cutRegion = ciImage.extent
        guard let cgImage = context.createCGImage(ciImage, from: cutRegion) else { return nil }
        let img = UIImage(cgImage: cgImage)
        let croppedImg = img.crop(to: (self.videoPreviewLayer?.frame.size)!)
        return croppedImg
        
    }
    // taking photo
    func capturingPhoto(completion: @escaping (UIImage?, Error?) -> Void) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
        self.photoCaptureCompletionBlock = completion
        
    }
    
    // capture image function
    
    // getting the captured image
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let x = error {
            self.photoCaptureCompletionBlock?(nil, x)
        }
        else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        }
    }
    
    // extracting the image in every scheduled time.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { [unowned self] in
            self.delegate?.returnedImage(image: uiImage)
        }
        
    }
}


