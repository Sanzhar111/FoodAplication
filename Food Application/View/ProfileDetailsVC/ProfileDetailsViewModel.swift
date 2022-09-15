//
//  ProfileDetailsViewModel.swift
//  Food Application
//
//  Created by Admin on 07.09.2022.
//

import Foundation
import UIKit
class ProfileDetailsViewModel {
    var cardArray = [Card]()
    
    func deleteAllProducts() {
        CartViewModel.shared.cartPositions.removeAll()
    }
    init () {
        self.cardArray.append(Card(userId: "", imageCard: nil, imageView: UIImage(named: "addCard"), cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false))
    }
}
