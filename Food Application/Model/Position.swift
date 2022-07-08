//
//  Position.swift
//  Food Application
//
//  Created by Admin on 04.06.2022.
//
import Foundation
import FirebaseFirestore

struct Position {
    var id:String
    var product:Productt
    var count:Int
    var cost:Int { // Вычисляемое свойство
        return product.price * self.count
    }
    var representation:[String:Any] {
        var repres = [String:Any]()
        repres["id"] = id
        repres["count"] = count
        repres["title"] = product.title
        repres["price"] = product.price
        repres["cost"] = self.cost
        return repres
    }
    internal init(id:String, product:Productt, count:Int) {
        self.id = id
        self.product = product
        self.count = count
    }
    init?(doc:QueryDocumentSnapshot) {
        //думаю будем использовать инициализатор при получении данных из firebase
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let price = data["price"] as? Int else { return nil }
        let product:Productt = Productt(id: "", title: title, imageURL: nil, price: price, descript: "")
        guard let count = data["count"] as? Int else { return nil }
        self.id = id
        self.product = product
        self.count = count
    }
}
