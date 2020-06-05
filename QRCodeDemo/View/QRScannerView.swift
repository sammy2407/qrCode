//
//  QRScannerView.swift
//  QRCodeDemo
//
//  Created by Shivam Maheshwari on 05/06/20.
//  Copyright © 2019 Shivam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWith(data: Product?)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    
    weak var delegate: QRScannerViewDelegate?
    var captureSession: AVCaptureSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
    
    
    private func initialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    
}
extension QRScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
       captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(data: Product?) {
        delegate?.qrScanningSucceededWith(data: data)
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let data = stringValue.data(using: .utf8)
            let jsonData = try? JSONDecoder().decode(Product.self, from: data!)
            found(data: jsonData)
        }
    }
}
