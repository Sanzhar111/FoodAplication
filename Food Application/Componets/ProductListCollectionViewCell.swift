//
//  ProductListCollectionViewCell.swift
//  Food Application
//
//  Created by Admin on 17.07.2022.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(position:Position) {
        self.nameLabel.text = position.product.title
      //  self.countLabel.text = String(position.count)
        self.priceLabel.text = String(position.cost) + "₽"
        self.imageView.image = position.product.image
       // self.descriptionLabel.text = position.product.descript
       // self.descriptionLabel.lineBreakMode = .byWordWrapping
      //  self.descriptionLabel.sizeToFit()
       // self.nameProductLabel.sizeToFit()
     //   self.countLabel.sizeToFit()
      //  self.priceLabel.sizeToFit()
       // self.nameProductLabel.lineBreakMode = .byWordWrapping
        
    }

}
