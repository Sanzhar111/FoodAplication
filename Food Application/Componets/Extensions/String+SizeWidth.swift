//
//  String+SizeWidth.swift
//  Food Application
//
//  Created by Admin on 07.06.2022.
//
import Foundation
import UIKit
extension String {
    func widthOfString(usingFont font:UIFont)->CGFloat {
        let fontAttributes = [NSAttributedString.Key.font:font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return ceil(size.width)
    }
}
