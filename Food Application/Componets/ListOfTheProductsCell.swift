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
//    var fullScreenHandler:((_ cell:ProductsCollectionViewCell,_ indexProduct:Int, _ collectionView:UICollectionView)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUp(product:Productt) {
        self.imageView.image = product.imageURL
        self.priceLabel.text = String(product.price)
        self.nameLabel.text = String(product.title)
    }
}
