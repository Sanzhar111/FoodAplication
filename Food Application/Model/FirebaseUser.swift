//
//  FirebaseUser.swift
//  Food Application
//
//  Created by Admin on 11.06.2022.
//

import Foundation


struct FirebaseUser {
    var id : String
    var name : String
    var phone : Int
    var address:String
    
    var representation:[String:Any] {
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["phone"] = self.phone
        repres["address"] = self.address
        return repres
    }
    
}
