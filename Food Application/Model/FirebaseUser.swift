//
//  FirebaseUser.swift
//  Food Application
//
//  Created by Admin on 11.06.2022.
//
import Foundation
import UIKit

struct FirebaseUser {
    var id : String
    var name : String
    var phone : String
    var address:String
    var profileImage:String
    
    var country:String
    var city:String
    var street:String
    var numberHouse:String
    var index:String
    var flatOrOfficeNmumber:String
    var porch:String
    var floor:String
    var intercom:String
    var commentsForACourier:String
    var cards:[Card]?
    var representation:[String:Any] {
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["phone"] = self.phone
        repres["address"] = self.address
        repres["profileImage"] = self.profileImage
        
        repres["country"] = self.country
        repres["city"] = self.city
        repres["street"] = self.street
        repres["numberHouse"] = self.numberHouse
        repres["index"] = self.index
        repres["flatOrOfficeNmumber"] = self.flatOrOfficeNmumber
        repres["porch"] = self.porch
        repres["floor"] = self.floor
        repres["intercom"] = self.intercom
        repres["commentsForACourier"] = self.commentsForACourier
        
        return repres
    }
    
}
