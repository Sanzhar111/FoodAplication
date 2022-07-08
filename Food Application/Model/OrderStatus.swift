//
//  OrderStatus.swift
//  Food Application
//
//  Created by Admin on 13.06.2022.
//
import Foundation
enum OrderStatus:String {
    case new = "Новый"
    case cooling = "Готовится"
    case delivery = "Доставляется"
    case complete = "Выполнен"
    case cancelled = "Отменен"
}
