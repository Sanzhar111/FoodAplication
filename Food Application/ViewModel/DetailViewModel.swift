//
//  DetailViewModel.swift
//  Food Application
//
//  Created by Admin on 03.06.2022.
//

import Foundation
class DetailViewModel {
    public var product:Productt
    public var  sizes = ["Большой", "Средний","Маленький"]
    init (product:Productt) {
        self.product = product
    }
    func getPrice(index:Int) -> Int {
        switch index {
        case 0 : return Int(Double(product.price))
        case 1 : return Int(Double(product.price) * 1.25)
        case 2 : return Int(Double(product.price) * 1.5)
        default: return 0
        }
    }
}
