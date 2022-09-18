//
//  PayCardViewController.swift
//  Food Application
//
//  Created by Admin on 02.09.2022.
//

import UIKit
protocol PayCardViewControllerDelegate:AnyObject {
    func upButton()
}
class PayCardViewController: UIViewController {
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cvcView: UIView!
    @IBOutlet weak var insertCardButton: UIButton!
    @IBOutlet weak var priceLabe: UILabel!
    @IBOutlet weak var numberCardLabel: UITextField!
    @IBOutlet weak var date1Label: UITextField!
    @IBOutlet weak var date2Label: UITextField!
    @IBOutlet weak var cvcLabel: UITextField!
    var selected = false
    let viewMoedel = PaycardViewModel()
    var priceVariable = ""
    var textForAButton = ""
    weak var delegate:PayCardViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(payButton)
        self.navigationItem.hidesBackButton = true
        setUpButton(image: UIImage(systemName: "square")!)
        seUpViews()
        setupDelegatesForTextFields()
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
            
            setUpButton(image: UIImage(systemName: "square")!)
            //let origImage = UIImage(systemName: "square")
            //let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            //insertCardButton.setImage(tintedImage, for: .normal)
            selected = false
        } else {
            setUpButton(image: UIImage(systemName: "checkmark.square")!)
            //let origImage2 = UIImage(systemName: "checkmark.square")
            //let tintedImage2 = origImage2?.withRenderingMode(.alwaysTemplate)
            //insertCardButton.setImage(tintedImage2, for: .normal)
            selected = true
        }
        print(selected)
        insertCardButton.isSelected = selected
       
    }
     @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        
         if viewMoedel.cardInfoIsEmpty(number: self.numberCardLabel.text ?? "", date1: self.date1Label.text ?? "", date2: self.date2Label.text ?? "", cvc: self.cvcLabel.text ?? "") {
             
                 let card = Card(userId: AuthService.shared.auth.currentUser!.uid, imageCard: nil, imageView: nil, cardNumber: numberCardLabel.text!, cvc: cvcLabel.text!, date1: date1Label.text!, date2: date2Label.text!, isSelected: false)
                 var order = Order(userId: AuthService.shared.auth.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue, paidCard: card)
                 order.positions = CartViewModel.shared.cartPositions
                     print("order.positions:\(order.positions)")
             viewMoedel.createOrder(order: order, saveCard: insertCardButton.isSelected)
                          
             showAlertController(textTitle: "Заказ успешно совершен", textOfAction1: "Закрыть") {
                // self.navigationController?.popViewController(animated: true)
                 self.navigationController?.popToRootViewController(animated: true)
                 self.dismiss(animated: true)
                 self.delegate?.upButton()
             }
         } else {
             showAlertController(textTitle: "Необходимо заполнить все поля", textOfAction1: "Закрыть") {}
         }
     }
    func showAlertController(textTitle:String,textOfAction1:String,completion:@escaping ()->() ) {
        let alertContoller = UIAlertController(title:textTitle, message: nil , preferredStyle: .alert)
        let alerAction = UIAlertAction(title: textOfAction1, style: .default) { action in
           // self?.viewModel.deleteAllProducts()
            completion()
        }
        alertContoller.addAction(alerAction)
        self.present(alertContoller, animated: true)
    }
}
extension PayCardViewController {
    func setupDelegatesForTextFields() {
        numberCardLabel.delegate = self
        date1Label.delegate = self
        date2Label.delegate = self
        cvcLabel.delegate = self
    }
}
extension PayCardViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            let allowedCharacters = "1234567890"
            let alloweCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return alloweCharacterSet.isSuperset(of: typedCharacterSet)
        }  else {
            return true
        }
    }*/
}

