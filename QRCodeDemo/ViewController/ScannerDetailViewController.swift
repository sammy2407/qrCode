//
//  ScannerDetailViewController.swift
//  QRCodeDemo
//
//  Created by Shivam Maheshwari on 05/06/20.
//  Copyright © 2019 Shivam. All rights reserved.
//

import UIKit

class ScannerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    
    var viewModel: ScannerDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListeners()
        setupTableView()
        setPayButton()
    }
    
    private func setPayButton() {
        let totalCartValue = viewModel.product.reduce(0) { $0 + Int($1.price)!}
        payButton.setTitle("Pay : $ \(totalCartValue)", for: .normal)
    }
    
    private func setupTableView() {
        productTableView.register(UINib(nibName: Constant.PRODUCT_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constant.PRODUCT_TABLE_VIEW_CELL_ID)
        productTableView.estimatedRowHeight = 150
        productTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addListeners() {
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.PRODUCT_TABLE_VIEW_CELL_ID, for: indexPath) as? ProductTableViewCell
        cell?.configureCell(with: viewModel.product[indexPath.row])
        
        return cell!
    }
    
    @IBAction func scanMore(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonAction(_ sender: Any) {
        
        // open payment screen
        
        
    }

}
