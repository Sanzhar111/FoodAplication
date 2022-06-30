//
//  CartViewModel.swift
//  Food Application
//
//  Created by Admin on 04.06.2022.
//

import Foundation

class CartViewModel {
    
    static let shared = CartViewModel()
    public var positions = [Position]()
    public var cartPositions = [Position]()
    var costForAll : Int {// вычисляемое свойство отвечающее за то
        // чтоб узнать стоимоть всей корзины
        var sum = 0
        for pos in cartPositions {
            sum += pos.cost
        }
        return sum
    }
    func addPosition(_ position:Position) {
        self.positions.append(position)
        self.cartPositions.append(position)
    }
    func getCartPositions() {
        
    }
    
    
    
}
