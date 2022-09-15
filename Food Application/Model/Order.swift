//
//  Order.swift
//  Food Application
//
//  Created by Admin on 13.06.2022.
//

import Foundation
import FirebaseFirestore
struct Order {
    var id:String = UUID().uuidString
    var userId:String
    var positions = [Position]()
    var date:Date
    var status:String
    var leaveNextToTheDoor:Bool = false
    var callBeforeDelivey:Bool = false
    var paidCard:Card
    var cost:Int { // Вычисляемое свойство
        var sum = 0
        for pos in positions {
            sum += pos.cost
        }
        return sum
    }
    var representation:[String:Any]  {
        var repres = [String:Any]()
        repres["id"] = id
        repres["userId"] = userId
        repres["date"] = Timestamp(date: date) 
        repres["status"] = status
        repres["leaveNextToTheDoor"] = leaveNextToTheDoor
        repres["callBeforeDelivey"] = callBeforeDelivey
        //repres["paidCard"] = paidCard.representation
        
        return repres
    }
    
    init(id:String = UUID().uuidString,userId:String,positions:[Position] = [Position](),date:Date,status:String,leaveNextToTheDoor:Bool = false,callBeforeDelivey:Bool = false,paidCard:Card) {
        self.id = id
        self.userId = userId
        self.positions = positions
        self.date = date
        self.status = status
        self.leaveNextToTheDoor = leaveNextToTheDoor
        self.callBeforeDelivey = callBeforeDelivey
        self.paidCard = paidCard
    }
    init?(doc:QueryDocumentSnapshot) {// QueryDocumentSnapshot
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil }
        guard let userId = data["userId"] as? String else { return nil }
        guard let date = data["date"] as? Timestamp else { return nil }
        guard let status = data["status"] as? String else { return nil }
        self.id = id
        self.userId = userId
        self.date = date.dateValue()
        self.status = status
        self.paidCard = Card(id: "", userId: "", imageCard: nil, imageView: nil, cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false)
    }
}
