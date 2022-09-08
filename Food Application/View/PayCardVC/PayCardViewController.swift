//
//  PayCardViewController.swift
//  Food Application
//
//  Created by Admin on 02.09.2022.
//

import UIKit

class PayCardViewController: UIViewController {
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cvcView: UIView!
    @IBOutlet weak var insertCardButton: UIButton!
    @IBOutlet weak var priceLabe: UILabel!
    var selected = false
    let viewMoedel = PaycardViewModel()
    var priceVariable = ""
    var textForAButton = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(payButton)
        self.navigationItem.hidesBackButton = true
        setUpButton(image: UIImage(systemName: "square")!)
        seUpViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        priceLabe.text = priceVariable
        payButton.setTitle(textForAButton, for: .normal)
    }
    func seUpViews() {
        cardView.dropShadow(colorView: .white , colorOfShadow: .gray, opacity: 0.6, offSet: CGSize.zero, radius: 4)
        cvcView.dropShadow(colorView:.systemGray6, colorOfShadow: .gray, opacity: 0.6, offSet: CGSize(width: 0, height: 4), radius: 4)

    }
    //opacity прозрачность [0..1]
    //shadowRadius как бы определяет на склько далеко будет
    //cardView.layer.shadowOffset = CGSize(width: -3, height: 0)
    // отрицателные значени width влево сдвигают, иначе вправо
    //
    func setUpButton(image:UIImage) {
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        insertCardButton.setImage(tintedImage, for: .normal)
        insertCardButton.tintColor = .black

    }
    @IBAction func closeButtonIsTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    @IBAction func insertCardButtonIsTapped(_ sender: Any) {
        
        if selected {
            setUpButton(image: UIImage(systemName: "checkmark.square")!)
            //let origImage2 = UIImage(systemName: "checkmark.square")
            //let tintedImage2 = origImage2?.withRenderingMode(.alwaysTemplate)
            //insertCardButton.setImage(tintedImage2, for: .normal)
            selected = !selected
        } else {
            setUpButton(image: UIImage(systemName: "square")!)
            //let origImage = UIImage(systemName: "square")
            //let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            //insertCardButton.setImage(tintedImage, for: .normal)

            selected = !selected
        }
        
        insertCardButton.isSelected = selected
       
    }
     @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        
             let order = Order(userId: AuthService.shared.auth.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue)
             //order.positions = CartViewModel.shared.cartPositions
             //CartViewModel.shared.cartPositions.removeAll()
             //priceForAllLabel.text = "0₽"
             //tableView.reloadData()
             //heightSetup()
             //self.tableView.alpha = 0
             //self.emptyLabel.alpha = 1
             //moveItemsToBottom()
             print("order.positions:\(order.positions)")
                 DataBaseService.shared.setOrder(order: order) { result in
                     switch result {
                     case .success(let order):
                         print("orders:\(order.cost)")
                         ProfileViewModel.shared.getOrders()
                     case .failure(let error):
                         print(error.localizedDescription)
                     }
                 }
             let alertContoller = UIAlertController(title:"Заказ успешно совершен", message:"Cпасибо за покупку!" , preferredStyle: .alert)
             let alerAction = UIAlertAction(title: "Закрыть", style: .default)
             alertContoller.addAction(alerAction)
             self.present(alertContoller, animated: true)
         
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
