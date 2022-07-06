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
        
        
     //   print("urlString = ProfileViewModel.profile?.profileImage = \(String(describing: ProfileViewModel.profile?.profileImage))")
         
    //    guard let url = URL(string: imageURL) else {
    //        print("no url")
     //       return
     //   }
        //dispatchGroup.enter()
      /*  URLSession.shared.dataTask(with: url) {   data, response, error in
            guard let data = data, error == nil else {
                print("error in a data or error")
                return
            }
            let image = UIImage(data: data)
          //  guard let self = self else {
              //  return
            //}
            DispatchQueue.main.async {
                self.image = image
            }
            
            print("getProfileImage almost finished")
                //./   dispatchGroup.leave()
        }.resume()
        */
        
        
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.price = price
        self.descript = descript
        print("\(self.id) / \(self.title) / \(self.imageURL) / \(self.price) / \(self.descript)")



    }

    
}
class Menu {
    var groups = [Group]()
    var popular = [Productt]()
    var tasty = [Productt]()
    var healthy = [Productt]()
    init() {
        //setup()
    }
  /*  func setup() {
        //Бургеры
        /*  let p1 = Productt(title: "Попул", imageURL: UIImage(named: "p1")!, price: 100, descript: "Самые Попул бургерыСамые Попул бургерыСамые Попул бургеры Самые Попул бургерыСамые Попул бургеры")
        let p2 = Productt(title: "Попул 2", imageURL: UIImage(named: "p1")!, price: 200, descript: "Самые Попул бургерыСамые Попул бургерыСамые Попул бургеры Самые Попул бургерыСамые Попул бургеры")
        let p3 = Productt(title: "Попул 3", imageURL: UIImage(named: "p1")!, price: 300, descript: "Самые Попул бургерыСамые Попул бургерыСамые Попул бургеры Самые Попул бургерыСамые Попул бургеры")
       
        popular.append(p1)
        popular.append(p2)
        popular.append(p3)
        popular.append(p3)
        popular.append(p3)
        popular.append(p3)
        popular.append(p3)*/
        
        let p4 = Productt(title: "вкусные 1", imageURL: UIImage(named: "p1")!, price: 100, descript: "Самые вкусные бургеры")
        let p5 = Productt(title: "вкусные 2", imageURL: UIImage(named: "p1")!, price: 200, descript: "Самые вкусные бургеры")
        let p6 = Productt(title: "вкусные 3", imageURL: UIImage(named: "p1")!, price: 300, descript: "Самые вкусные бургеры")

        tasty.append(p4)
        tasty.append(p5)
        tasty.append(p6)
        tasty.append(p6)
        tasty.append(p6)
        tasty.append(p6)
        tasty.append(p6)
        tasty.append(p6)

        let p7 = Productt(title: "Полез", imageURL: UIImage(named: "p1")!, price: 400, descript: "Самые Полез бургеры")
        let p8 = Productt(title: "Полез 2", imageURL: UIImage(named: "p1")!, price: 500, descript: "Самые Полез бургеры")
        let p9 = Productt(title: "Полез 3", imageURL: UIImage(named: "p1")!, price: 500, descript: "Самые Полез бургеры")

        healthy.append(p7)
        healthy.append(p8)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)
        healthy.append(p9)

        
        //_____________________________________________________________________________________________________________________________//
    
        
     //   let pizaGroupIn1 = Group(name: "Популярное", groups: nil, products: [p1,p2,p3], image: UIImage(named: "p1")!)
    //    let pizaGroupIn2 = Group(name: "Самые вкусные", groups: nil, products: [p4,p5,p6], image: UIImage(named: "p1")!)
    //    let pizaGroupIn3 = Group(name: "Диетические", groups: nil, products: [p7,p8,p9], image: UIImage(named: "p1")!)

    //    groups.append(pizaGroupIn1)
   //     groups.append(pizaGroupIn2)
   //     groups.append(pizaGroupIn3)
      //  let pizzaGroup = Group(name: "Бургер", groups: [pizaGroupIn1,pizaGroupIn2,pizaGroupIn3], products: nil, image: UIImage(named: "p1")!)
        
        // Тортильи
      /*
        let t1 = Product(name: "Тортилья", price: 100, image: UIImage(named: "p2")!)
        let t2 = Product(name: "Тортилья 2", price: 200, image: UIImage(named: "p2")!)
        let t3 = Product(name: "Тортилья 3", price: 300, image: UIImage(named: "p2")!)

        
        let t4 = Product(name: "Тортилья 4", price: 100, image: UIImage(named: "p2")!)
        let t5 = Product(name: "Тортилья 5", price: 200, image: UIImage(named: "p2")!)
        let t6 = Product(name: "Тортилья 6", price: 300, image: UIImage(named: "p2")!)

        let t7 = Product(name: "Тортилья 7", price: 100, image: UIImage(named: "p2")!)
        let t8 = Product(name: "Тортилья 8", price: 200, image: UIImage(named: "p2")!)
        let t9 = Product(name: "Тортилья 9", price: 300, image: UIImage(named: "p2")!)

        let tortGroupIn1 = Group(name: "Тортилья с колбасой", groups: nil, products: [t1,t2,t3,t1,t2,t3,t1,t2,t3,t1,t2,t3], image: UIImage(named: "p2")!)
        let tortGroupIn2 = Group(name: "Тортилья с мясом", groups: nil, products: [t4,t5,t6], image: UIImage(named: "p2")!)
        let tortGroupIn3 = Group(name: "Тортилья без мяса", groups: nil, products: [t7,t8,t9], image: UIImage(named: "p2")!)

        let tortGroup = Group(name: "Тортилья", groups: [tortGroupIn1,tortGroupIn2,tortGroupIn3], products: nil, image: UIImage(named: "p2")!)
        
        // шава
        let s1 = Product(name: "Шава", price: 100, image: UIImage(named: "p3")!)
        let s2 = Product(name: "Шава 2", price: 200, image: UIImage(named: "p3")!)
        let s3 = Product(name: "Шава 3", price: 300, image: UIImage(named: "p3")!)

        
        let s4 = Product(name: "Шава 4", price: 100, image: UIImage(named: "p3")!)
        let s5 = Product(name: "Шава 5", price: 200, image: UIImage(named: "p3")!)
        let s6 = Product(name: "Шава 6", price: 300, image: UIImage(named: "p3")!)

        let s7 = Product(name: "Шава 7", price: 100, image: UIImage(named: "p3")!)
        let s8 = Product(name: "Шава 8", price: 200, image: UIImage(named: "p3")!)
        let s9 = Product(name: "Шава 9", price: 300, image: UIImage(named: "p3")!)

        let shavaGroupIn1 = Group(name: "Шава ", groups: nil, products: [s1,s2,s3], image: UIImage(named: "p3")!)
        let shavaGroupIn2 = Group(name: "Шава", groups: nil, products: [s4,s5,s6], image: UIImage(named: "p3")!)
        let shavaGroupIn3 = Group(name: "Шава", groups: nil, products: [s7,s8,s9], image: UIImage(named: "p3")!)

        let shavaGroup = Group(name: "Шава", groups: [shavaGroupIn1,shavaGroupIn2,shavaGroupIn3], products: nil, image: UIImage(named: "p3")!)
*/
       // groups.append(pizzaGroup)
        //groups.append(tortGroup)
    }*/
}

