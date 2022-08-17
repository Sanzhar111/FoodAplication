//
//  OrderDetailsCollectionViewCell.swift
//  Food Application
//
//  Created by Admin on 17.08.2022.
//

import UIKit

class OrderDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var priceForOneLabel: UILabel!
    @IBOutlet weak var countProductsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //countProductsLabel.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        //countProductsLabel.layer.cornerRadius = 5
    }
    func setup(product:Position) {
        self.imageView.image = product.product.image
        self.priceForOneLabel.text = String(product.product.price) + "₽/шт"
        self.countProductsLabel.text = String(product.count) + " шт."
    }
}
