//
//  ProductTableViewCell.swift
//  QRCodeDemo
//
//  Created by Shivam Maheshwari on 05/06/20.
//  Copyright © 2020 Shivam. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with product: Product) {
        productTitle.text = product.title
        productPrice.text = Constant.DOLLAR_SIGN + String(product.price)
        let imageData = try? Data(contentsOf: URL(string: product.image)!)
        productImage.image = UIImage(data: imageData!)
    }
}
