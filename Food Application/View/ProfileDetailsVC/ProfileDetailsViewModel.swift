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
    var timeArray:[String] = [String]()
    private var arrayOfMonths = ["01":"января","02":"февраля","03":"марта","04":"апреля","05":"мая","06":"июня","07":"июля","08":"августа","09":"сентября","10":"октября","11":"ноября","12":"декабря"]
    
    init () {
        self.cardArray.append(Card(userId: "", imageCard: nil, imageView: UIImage(named: "addCard"), cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false))
    }
    func deleteAllProducts() {
        CartViewModel.shared.cartPositions.removeAll()
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
    func getDate() -> String {
        let date = Date().string(format: "dd.MM.yy")
        let day = "\(date[date.index(date.startIndex, offsetBy: 0) ... date.index(date.startIndex, offsetBy: 1)])"
        let month = "\(date[date.index(date.startIndex, offsetBy: 3) ... date.index(date.startIndex, offsetBy: 4)])"
        let monthInWords = arrayOfMonths[month]
        /*for i in 0 ..< date.count {
            //date.index(date.startIndex, offsetBy: i)
            if i < 2 {
                day += "\(date[date.index(date.startIndex, offsetBy: i)])"
            } else if i > 2 && i < 5 {
                month += "\(date[date.index(date.startIndex, offsetBy: i)])"
            } 
            //print(date[date.index(date.startIndex, offsetBy: i)])
        }*/
        return day + " " + monthInWords!
    }
    func getTime() {
        let date = Date().string(format: "HH:mm:ss.SSS")
        var hour = "\(date[date.index(date.startIndex, offsetBy: 0) ... date.index(date.startIndex, offsetBy: 1)])"
        let minutes = "\(date[date.index(date.startIndex, offsetBy: 3) ... date.index(date.startIndex, offsetBy: 4)])"
        for _ in 0...12 {
            if Int(hour)! + 2 == 24 {
                hour = String(0)
               // hour = String(Int(hour)! + 1)
            } else {
                hour = String(Int(hour)! + 2)
                if Int(hour)! + 2 == 24 {
                    timeArray.append("\(Int(hour)!)-00")
                    continue
                }
            }
            if Int(hour)! < 8 {
                timeArray.append("0\(Int(hour)!)-0\(Int(hour)! + 2)")
            } else if Int(hour)! == 8 {
                timeArray.append("0\(Int(hour)!)-\(Int(hour)! + 2)")
            } else {
                timeArray.append("\(Int(hour)!)-\(Int(hour)! + 2)")
            }
            print("h",hour)
        }
        print(timeArray)
        print(hour)
        print(minutes)
        print(date)
    }
}
