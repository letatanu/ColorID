//
//  CameraLayer.swift
//  ColorID
//
//  Created by Le Nhut on 6/26/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}


class Camera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? //render the camera view finder
    weak var delegate: FrameExtractorDelegate?
    private let sessionQueue = DispatchQueue(label: "session queue")
//    private var videoPreviewFrame = CGRect()
    private let position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.high
    private var centerPointRec = CAShapeLayer()
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let context = CIContext()
    private var sizeOfCenterPoint = CGFloat(0)
    // MARK: AVSession configuration
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
    private func selectCaptureDevice(positionCamera: String) -> AVCaptureDevice? {
        if positionCamera == "front" {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { return nil}
            return device
        }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else { return nil }
        return device
    }
    
    private func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    private func configureSession(frame: CGRect) {
        guard permissionGranted else { return }
        
        //adding input device
        captureSession.sessionPreset = quality
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        guard let captureDevice = selectCaptureDevice(positionCamera: "back") else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        
        //adding output device
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
        guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = position == .front
        
    }
    
    init(frame: CGRect, sizeOfCenterPoint: Int = 20) {
        super.init()
        self.sizeOfCenterPoint = CGFloat(sizeOfCenterPoint)
        checkPermission()
        
        //adding preview frame
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.frame = frame
        self.centerPointRec = self.recCenter(radius: CGFloat(sizeOfCenterPoint), lineWidth: CGFloat(4))
        self.videoPreviewLayer?.addSublayer(self.centerPointRec)
        
        //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
        sessionQueue.async { [unowned self] in
            self.configureSession(frame: frame)
            self.captureSession.startRunning()
        }
        
        
    }
    func recCenter(radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let rec = CAShapeLayer()
        rec.path = UIBezierPath(
            arcCenter: CGPoint(x: self.videoPreviewLayer!.bounds.width*0.5, y: self.videoPreviewLayer!.bounds.height*0.5),
            radius: radius - lineWidth*0.5 ,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true).cgPath
        rec.fillColor = UIColor.clear.cgColor
        rec.strokeColor = UIColor.white.cgColor
        rec.lineWidth = lineWidth
        rec.opacity = 1
        return rec
    }
    
    func updatePreviewLayer(size: CGSize) {
        self.videoPreviewLayer?.frame.size = size
    }
    
    // MARK: Sample buffer to UIImage conversion
    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let cutRegion = ciImage.extent
        guard let cgImage = context.createCGImage(ciImage, from: cutRegion) else { return nil }
        let img = UIImage(cgImage: cgImage)
        let croppedImg = img.crop(to: (self.videoPreviewLayer?.frame.size)!)
        let radius = self.sizeOfCenterPoint
        let lineWidth = self.centerPointRec.lineWidth
        let finalImg = croppedImg.imageByApplyingClippingCenterCircleBezierPath(radius: radius, lineWidth: lineWidth)
//        DispatchQueue.main.async { [unowned self] in
//            let pixelClusters = finalImg.clusters()
//        }
        return finalImg
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
                DispatchQueue.main.async { [unowned self] in
                    self.delegate?.captured(image: uiImage)
                }
    }
}


