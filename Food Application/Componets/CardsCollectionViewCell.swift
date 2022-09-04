//
//  CardsCollectionViewCell.swift
//  Food Application
//
//  Created by Admin on 19.08.2022.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var myView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 5
    }
    func setUp(card:Card) {
        if card.imageView != nil {
            mainImageView.image = card.imageView
            self.cardNumberLabel.text = card.cardNumber
            self.cardImage.image = card.imageCard
        } else {
            mainImageView.image = card.imageView
            self.cardNumberLabel.text = "** " + card.cardNumber
            self.cardImage.image = card.imageCard

        }
    }
}
