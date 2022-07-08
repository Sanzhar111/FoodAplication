//
//  DetailViewController.swift
//  Food Application
//
//  Created by Admin on 30.05.2022.
//
import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentControllFood: UISegmentedControl!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var countProductLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var  selectedIndex = 0
    var countProduct = 1
    var viewModel:DetailViewModel!
    var size   =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = viewModel.product.image
        self.nameLabel.text = viewModel.product.title
        self.priceLabel.text = String(viewModel.product.price)+"₽"
        self.descriptionLabel.text = viewModel.product.descript
        self.segmentControllFood.addTarget(self, action: #selector(getPrice), for: .valueChanged)
        self.stepper.stepValue = 1
        self.stepper.addTarget(self, action: #selector(getCount), for: .valueChanged)
    }
    @objc func getCount(target:UIStepper) {
        if target == stepper {
            countProduct = Int(target.value)
        }
    }
    @objc func getPrice(target:UISegmentedControl) {
        if target == self.segmentControllFood {
            selectedIndex = target.selectedSegmentIndex
            priceLabel.text = String(viewModel.getPrice(index: selectedIndex))
    }
}
    @IBAction func stepperIsTapped(_ sender: UIStepper) {
        countProductLabel.text = Int(sender.value).description
    }
    
    @IBAction func buttonIsTapped(_ sender: UIButton) {
        var position = Position(id: viewModel.product.id, product: viewModel.product, count: self.countProduct)
        position.product.price = viewModel.getPrice(index: selectedIndex)
        CartViewModel.shared.addPosition(position)
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
