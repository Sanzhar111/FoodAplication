//
//  Product.swift
//  Food Application
//
//  Created by Admin on 24.05.2022.
//

import Foundation
import UIKit
import Firebase
class Productt {
    var id:String = UUID().uuidString
    var title:String
    var imageURL:String?
    var price:Int
    var descript:String
    var image:UIImage?
    //var ordersCount:Int
    //var isReccomend:Bool
    init(title: String, imageURL: String?, price: Int, descript:String) {
        self.title = title
        self.imageURL = imageURL
        self.price = price
        self.descript = descript
    }

    init(id:String, title: String, imageURL: String?, price: Int, descript:String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.price = price
        self.descript = descript
    }
    init?(doc:QueryDocumentSnapshot) {// QueryDocumentSnapshot
        //думаю будем использовать инициализатор при получении данных из firebase
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let imageURL = data["imageURL"] as? String else { return nil }
        guard let price = data["price"] as? Int else { return nil }
        guard let descript = data["descript"] as? String else { return nil }
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.price = price
        self.descript = descript
    }
}


