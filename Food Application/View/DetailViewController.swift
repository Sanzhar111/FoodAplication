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
    
    
    // двнный конетроллеер не обладает вью моделью а имеет на него ссылку и при посылке релиз вью контроллеру
    var size   =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.imageView.image = viewModel.product.imageURL
        self.nameLabel.text = viewModel.product.title
        self.priceLabel.text = String(viewModel.product.price)+"₽"
        self.descriptionLabel.text = viewModel.product.descript
        self.segmentControllFood.addTarget(self, action: #selector(getPrice), for: .valueChanged)
        self.stepper.stepValue = 1
        self.stepper.addTarget(self, action: #selector(getCount), for: .valueChanged)
        //self.segmentControllFood. UISegmentedControl(items: viewModel.sizes)
        //  collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
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
    
/*
extension DetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.setUp(product: product!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //UICollectionViewDelegateFlowLayout
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {//UICollectionViewDelegate
               
    }

}
*/
}
