//
//  ChooseCollectionViewCell.swift
//  Food Application
//
//  Created by Admin on 19.07.2022.
//

import UIKit
protocol ChooseCollectionViewCellDelegate:class {
    func addValue(value:Int,sender:ChooseCollectionViewCell)
    func deleteRow(sender:ChooseCollectionViewCell)
}
class ChooseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var countProductLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    weak var delegate:ChooseCollectionViewCellDelegate?
    var currentValue = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stepper.stepValue = 1
        self.stepper.addTarget(self, action: #selector(getCount), for: .valueChanged)
    }
    @IBAction func deleteButtonIsTapped(_ sender: UIButton) {
        delegate?.deleteRow(sender: self)
    }
    @objc func getCount(target:UIStepper) {
        if target == stepper {
            currentValue = Int(target.value)
            countProductLabel.text = String(currentValue)
            print("currentValue = \(currentValue)")
            delegate?.addValue(value: currentValue, sender: self)
            
        }
    }
    func setup(postions:Position) {
        countProductLabel.text = String(postions.count)
        self.stepper.value = Double(postions.count)
    }
    
}
