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
        Utilities.styleFilledButton(addToBasketButton)
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
        let position = Position(id: viewModel.product.id, product: viewModel.product, count: self.countProduct)
        position.product.price = viewModel.getPrice(index: selectedIndex)
        if let index = CartViewModel.shared.cartPositions.firstIndex(where: { pos in
            pos == position
        }) {
            print(index)
    //        CartViewModel.shared.positions[index].count += self.countProduct
            self.navigationController?.dismiss(animated: true)
         
            
            //showToast(message: "Добавлено в корзину")
            
            
            //ergwegwegwegweg
            CartViewModel.shared.cartPositions[index].count += self.countProduct
        } else {
            print("no index")
           // showToast(message: "Добавлено в корзину")
            self.navigationController?.dismiss(animated: true)
            //wergwegwergewr
            CartViewModel.shared.addPosition(position)
        }
        
        print(CartViewModel.shared.cartPositions.count," / ",CartViewModel.shared.cartPositions.count)
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func showToast(message:String) {
        guard let window = UIApplication.shared.keyWindow  else {
            return
        }
        let toastLavel = UILabel()
        toastLavel.text = message
        toastLavel.textAlignment = .center
        toastLavel.font = .systemFont(ofSize: 18)
        toastLavel.textColor = .white
        toastLavel.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        toastLavel.numberOfLines = 0
        let textSize = toastLavel.intrinsicContentSize
        toastLavel.frame = CGRect(x: 20, y: window.frame.minY + 50, width: self.view.frame.width - 20, height: textSize.height + 30)
        toastLavel.alpha = 0
        toastLavel.center.x = window.center.x
        toastLavel.layer.cornerRadius = 10
        toastLavel.layer.masksToBounds = true
        window.addSubview(toastLavel)
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveLinear, animations: {
            toastLavel.layer.masksToBounds = true
            var frame = toastLavel.frame
            frame.origin.x = frame.origin.x
            frame.origin.y = frame.origin.y + 10
            toastLavel.frame = frame
            toastLavel.alpha = 1
        }, completion: { finished in
            print("Animation completed")
        })

        UIView.animate(withDuration: 0.2, delay: 2.1, options: .curveLinear, animations: {
            var frame = toastLavel.frame
            frame.origin.x = frame.origin.x
            frame.origin.y = frame.origin.y - 10
            toastLavel.frame = frame
            toastLavel.alpha = 0
        }, completion: { finished in
            toastLavel.removeFromSuperview()
            print("Animation completed")
        })
        
    }
    
    
}

