//
//  ListOfProductsTableViewCell.swift
//  Food Application
//
//  Created by Admin on 08.08.2022.
//

import UIKit

class ListOfProductsTableViewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myDescriptionLabel: UILabel!
    @IBOutlet weak var myPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUp(product:Productt) {
        self.myImageView.image = product.image
        self.myPriceLabel.text = String(product.price)+"₽"
        self.myNameLabel.text = String(product.title)
        self.myDescriptionLabel.text = product.descript
    }
    
}
