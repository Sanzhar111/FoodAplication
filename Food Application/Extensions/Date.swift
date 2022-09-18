//
//  Date.swift
//  Food Application
//
//  Created by Admin on 16.09.2022.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
