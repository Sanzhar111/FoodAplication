//
//  ProfileDetailsViewModel.swift
//  Food Application
//
//  Created by Admin on 07.09.2022.
//

import Foundation

class ProfileDetailsViewModel {
    func deleteAllProducts() {
        CartViewModel.shared.cartPositions.removeAll()
    }

}
