//
//  InfoForDeliveryViewModel.swift
//  Food Application
//
//  Created by Admin on 29.08.2022.
//

import Foundation
class InfoForDeliveryViewModel {
    func checkTextField(name:String,country:String,city:String,street:String,numberHouse:String,phone:String) -> Bool {
    if name == "" || country == "" || city == "" || street == "" || numberHouse == "" || phone == "" {
        return false
    } else {
        return true
    }
    }
    func createAddress(country:String,city:String,street:String,numberHouse:String) -> String {
        var address = ""
        if country != "" {
            address += country+","//Russia,
        }
        if city != "" {
            address += "г." + city + ","//Russia,г.SPB,
        }
        if street != "" {
            address += "ул." + street + ","
        }
        if numberHouse != "" {
            address += "д." + numberHouse + "."
        }
      //  Россия,Санкт-Петербург,Торжковская улица, 15, кв./офис 45, подъезд 2, этаж 3
        return address
    }

    
}
