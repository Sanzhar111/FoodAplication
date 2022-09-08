//
//  InfoForDeliveryViewController.swift
//  Food Application
//
//  Created by Admin on 27.08.2022.
//

import UIKit
protocol InfoForDeliveryDelegate:AnyObject {
    func updateInfo(name:String,address :String,country:String,city:String,street:String,numberHouse:String,phone:String)
}

class InfoForDeliveryViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    weak var delegate:InfoForDeliveryDelegate?
    var viewModel = InfoForDeliveryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(button)
        setUpDelegates()
        self.navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLabels()
    }
    func setUpDelegates() {
        nameTextField.delegate = self
        countryTextField.delegate = self
        cityTextField.delegate = self
        streetTextField.delegate = self
        houseNumberTextField.delegate = self
        numberTextField.delegate = self
    }
    func setUpLabels() {
        nameTextField.text = ProfileViewModel.shared.profile?.name
        countryTextField.text = ProfileViewModel.shared.profile?.country
        cityTextField.text = ProfileViewModel.shared.profile?.city
        streetTextField.text = ProfileViewModel.shared.profile?.street
        houseNumberTextField.text = ProfileViewModel.shared.profile?.numberHouse
        numberTextField.text = ProfileViewModel.shared.profile?.phone
    }
    @IBAction func closeButtonIsTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func continueButtonIsTapped(_ sender: Any) {
        if viewModel.checkTextField(name: nameTextField.text ?? "", country: countryTextField.text ?? "", city: cityTextField.text ?? "", street: streetTextField.text ?? "", numberHouse: houseNumberTextField.text ?? "", phone: numberTextField.text ?? "") {
            showEditViewController()
            let address = viewModel.createAddress(country: countryTextField.text ?? "", city: cityTextField.text ?? "", street: streetTextField.text ?? "", numberHouse: houseNumberTextField.text ?? "")
              self.delegate?.updateInfo(name: nameTextField.text ?? "", address: address, country: countryTextField.text ?? "", city: cityTextField.text ?? "", street: streetTextField.text ?? "", numberHouse: houseNumberTextField.text ?? "", phone: numberTextField.text ?? "")

        } else {
            showDefaultAlertController()
        }
    }
    func showEditViewController() {        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    private func showDefaultAlertController() {
        let alertContoller = UIAlertController(title:"Невозможно выполнить действие", message: "Необходимо заполнить все поля", preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "Закрыть", style: .default)
        alertContoller.addAction(alerAction)
        self.present(alertContoller, animated: true)
    }
    func showBehindViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as! ProfileDetailsViewController
        //nextViewController.delegate = self
        
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

