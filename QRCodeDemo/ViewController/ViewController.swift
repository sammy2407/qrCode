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
            scanButton.setTitle("Start scanning", for: .normal)
        } else {
            scannerView.startScanning()
            scanButton.setTitle("Stop scanning", for: .normal)
        }
    }
    
    private func addAlertForFail() {
        let alertViewController = UIAlertController(title: "Alert",
                                                    message: "Unable to scan. Try again!",
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertViewController.addAction(okAction)
        self.present(alertViewController,
                     animated: true,
                     completion: nil)
    }

}




extension ViewController: QRScannerViewDelegate {
    
    func qrScanningDidFail() {
        // show alert on fail
        addAlertForFail()
    }
    
    func qrScanningDidStop() {
        
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        // if scanning is successful and we got result then we will add product to the cart.
        product.append(Product(title: "Hatchback",
                                price: 40000,
                                image: UIImage(named: "hatchBackCar")!))
        
        scannerView.stopScanning()
        scanButton.setTitle("Start scanning", for: .normal)
        
        // taking dummy data, just to be sure that this item will be added in the cart once the scanning process completes with metadata
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let scannerDetailVC = storyBoard.instantiateViewController(identifier: "ScannerDetailViewController") as! ScannerDetailViewController
        scannerDetailVC.viewModel = ScannerDetailViewModel(product: product)
        present(scannerDetailVC,
                animated: true,
                completion: nil)
    }
    
}
 

