//
//  DeliveryInfoViewModel.swift
//  Food Application
//
//  Created by Admin on 25.08.2022.
//

import Foundation

class DeliveryInfoViewModel {
    func address(country:String,city:String,street:String,numberHouse:String,index:String,flatOrOfficeNmumber:String,porch:String,floor:String,intercom:String) -> String {
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
            address += "д." + numberHouse + ","
        }
        if index != "" {
            address += index + ","
        }
        if flatOrOfficeNmumber != "" {
            address += "кв./офис " + flatOrOfficeNmumber + ","
        }
        if porch != "" {
            address += "подъезд " + porch + ","
        }
        if floor != "" {
            address += "этаж " + floor + ","
        }
        if intercom != "" {
            address += "домофон " + intercom + "."
        }
      //  Россия,Санкт-Петербург,Торжковская улица, 15, кв./офис 45, подъезд 2, этаж 3
        return address
    }
}
