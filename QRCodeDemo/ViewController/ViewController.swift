//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by Shivam Maheshwari on 05/06/20.
//  Copyright © 2019 Shivam. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var product = [Product]()

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scannerView: QRScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
        
    }
    private func addListener() {
        scannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        if scannerView.isRunning {
            scannerView.stopScanning()
            scanButton.setTitle(Constant.START_SCANNING, for: .normal)
        } else {
            scannerView.startScanning()
            scanButton.setTitle(Constant.STOP_SCANNING, for: .normal)
        }
    }
    
    private func addAlertForFail() {
        let alertViewController = UIAlertController(title: Constant.ALERT,
                                                    message: Constant.ALERT_MESSAGE,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.OKAY_MESSAGE, style: .default)
        alertViewController.addAction(okAction)
        self.present(alertViewController,
                     animated: true,
                     completion: nil)
    }

}

extension ViewController: QRScannerViewDelegate {
    
    func qrScanningSucceededWith(data: Product?) {
        
        guard let data = data else { return }
        product.append(data)
               
        scannerView.stopScanning()
        scanButton.setTitle(Constant.START_SCANNING, for: .normal)
               
        // taking dummy data, just to be sure that this item will be added in the cart once the scanning process completes with metadata
               
        let storyBoard: UIStoryboard = UIStoryboard(name: Constant.MAIN , bundle: nil)
        let scannerDetailVC = storyBoard.instantiateViewController(identifier: Constant.SCANNER_DETAILS_VC) as! ScannerDetailViewController
               scannerDetailVC.viewModel = ScannerDetailViewModel(product: product)
               present(scannerDetailVC,
                       animated: true,
                       completion: nil)
    }
    
    
    func qrScanningDidFail() {
        // show alert on fail
        addAlertForFail()
    }
    
    func qrScanningDidStop() {
        
    }
    
}
 

