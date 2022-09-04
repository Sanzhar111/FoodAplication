//
//  UIView + dropShadow.swift
//  Food Application
//
//  Created by Admin on 02.09.2022.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow(colorView:UIColor,colorOfShadow: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        //cardView.center = self.view.center
        self.backgroundColor = UIColor.yellow
        self.layer.shadowColor = colorOfShadow.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet//CGSize.zero
        self.layer.shadowRadius = radius
        self.backgroundColor = colorView
        //cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        //cardView.layer.shouldRasterize = true
       // cardView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1

    }

}
