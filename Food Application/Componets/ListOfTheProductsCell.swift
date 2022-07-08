//
//  ListOfTheProductsCell.swift
//  Food Application
//
//  Created by Admin on 01.06.2022.
//
import UIKit
class ListOfTheProductsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUp(product:Productt) {
        self.imageView.image = product.image
        self.priceLabel.text = String(product.price)
        self.nameLabel.text = String(product.title)
    }
}
