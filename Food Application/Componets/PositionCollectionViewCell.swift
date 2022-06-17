//
//  PositionCollectionViewCell.swift
//  Food Application
//
//  Created by Admin on 06.06.2022.
//

import UIKit

class PositionCollectionViewCell: UITableViewCell {

    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(position:Position) {
        self.nameProductLabel.text = position.product.title
        self.countLabel.text = String(position.count)
        self.priceLabel.text = String(position.cost) + "₽"
    }
}
