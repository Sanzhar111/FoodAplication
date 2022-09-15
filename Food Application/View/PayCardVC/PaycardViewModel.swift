//
//  PaycardViewModel.swift
//  Food Application
//
//  Created by Admin on 05.09.2022.
//

import Foundation

class PaycardViewModel {
    func cardInfoIsEmpty(number:String,date1:String,date2:String,cvc:String) -> Bool {
        if number.isEmpty || date1.isEmpty || date2.isEmpty || cvc.isEmpty {
            return false
        } else {
            return true
        }
    }
    func createOrder (order:Order) {
        DataBaseService.shared.setOrder(order: order) { result in
            switch result {
            case .success(let order):
                print("orders:\(order.cost)")
                ProfileViewModel.shared.getOrders()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        DataBaseService.shared.setCardToUser(card: order.paidCard) { result in
            switch result {
            case .success(let card): print("The card ",card)
            case .failure(let error): print(error.localizedDescription)
            }
        }
        CartViewModel.shared.cartPositions.removeAll()
    }
}
