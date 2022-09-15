//
//  File.swift
//  Food Application
//
//  Created by Admin on 19.08.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
struct Card {
    var id:String = UUID().uuidString
    var userId:String
    var cardNumber:String
    var imageCard:UIImage?
    var imageView:UIImage?
    var cvc:String
    var date1:String
    var date2:String
    var isSelected:Bool
    
    var representation:[String:Any]  {
        var repres = [String:Any]()
        repres["id"] = id
        repres["userId"] = userId
        repres["cardNumber"] = cardNumber
        repres["cvc"] = cvc
        repres["date1"] = date1
        repres["date2"] = date2
        repres["isSelected"] = isSelected
        return repres
    }
    init(id:String = UUID().uuidString,userId:String,imageCard:UIImage?,imageView:UIImage?,cardNumber:String,cvc:String,date1:String,date2:String,isSelected:Bool) {
        self.id = id
        self.userId = userId
        self.imageCard = imageCard
        self.imageView = imageView
        self.cardNumber = cardNumber
        self.cvc = cvc
        self.date1 = date1
        self.date2 = date2
        self.isSelected = isSelected
    }
    init?(doc:QueryDocumentSnapshot) {// QueryDocumentSnapshot
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil }
        guard let userId = data["userId"] as? String else { return nil }
        guard let cardNumber = data["cardNumber"] as? String else { return nil }
        guard let cvc = data["cvc"] as? String else { return nil }
        guard let date1 = data["date1"] as? String else { return nil }
        guard let date2 = data["date2"] as? String else { return nil }
        guard let isSelected = data["isSelected"] as? Bool else { return nil }
        self.id = id
        self.userId = userId
        self.cardNumber = cardNumber
        self.cvc = cvc
        self.date1 = date1
        self.date2 = date2
        self.isSelected = isSelected
        
    }


}
