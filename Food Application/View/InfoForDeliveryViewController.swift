//
//  InfoForDeliveryViewController.swift
//  Food Application
//
//  Created by Admin on 27.08.2022.
//

import UIKit

class InfoForDeliveryViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(button)
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func closeButtonIsTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)

    }
    @IBAction func continueButtonIsTapped(_ sender: Any) {
        showEditViewController()
    }
    func showEditViewController() {        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
}
extension InfoForDeliveryViewController : UITextFieldDelegate {
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

