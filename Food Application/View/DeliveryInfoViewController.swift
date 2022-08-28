//
//  DeliveryInfoViewController.swift
//  Food Application
//
//  Created by Admin on 22.08.2022.
//

import UIKit
protocol DeliveryInfoViewControllerDelegate : AnyObject {
    func changeInfo(information:String,name:String,phoneNumber:String)
}
class DeliveryInfoViewController: UIViewController {
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var numberHouseLabel: UITextField!
    @IBOutlet weak var indexLabel: UITextField!
    @IBOutlet weak var flatOrOfficeNmumberLabel: UITextField!
    @IBOutlet weak var porchLabel: UITextField!
    @IBOutlet weak var floorLabel: UITextField!
    @IBOutlet weak var intercomLabel: UITextField!
    @IBOutlet weak var commentsForACourierLabel: UITextField!
    
    @IBOutlet weak var fullnameLabel: UITextField!
    @IBOutlet weak var phoneUserLabel: UITextField!
    @IBOutlet weak var labelDelivery: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate:DeliveryInfoViewControllerDelegate?
    var viewModel = DeliveryInfoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(saveButton)
        labelDelivery.sizeToFit()
        setUpDelegate()
        //self.navigationItem.leftBarButtonItems = []
        // hide the default back buttons
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLabels()
    }
    
    @IBAction func saveButtonisTapped(_ sender: UIButton) {
        let address = viewModel.address(country: countryLabel.text ?? "", city: cityLabel.text ?? "", street: streetLabel.text ?? "", numberHouse: numberHouseLabel.text ?? "", index: indexLabel.text ?? "", flatOrOfficeNmumber: flatOrOfficeNmumberLabel.text ?? "", porch: porchLabel.text ?? "", floor: floorLabel.text ?? "", intercom: intercomLabel.text ?? "")
        setUpInformation()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.delegate?.changeInfo(information: address,name:fullnameLabel.text ?? "",phoneNumber:phoneUserLabel.text ?? "0" )
        
    }
    func setUpInformation() {
        ProfileViewModel.shared.profile?.country = countryLabel.text ?? ""
        ProfileViewModel.shared.profile?.city = cityLabel.text ?? ""
        ProfileViewModel.shared.profile?.street = streetLabel.text ?? ""
        ProfileViewModel.shared.profile!.numberHouse = numberHouseLabel.text ?? ""
        ProfileViewModel.shared.profile?.index = indexLabel.text ?? ""
        ProfileViewModel.shared.profile!.flatOrOfficeNmumber = flatOrOfficeNmumberLabel.text ?? ""
        ProfileViewModel.shared.profile!.porch = porchLabel.text ?? ""
        ProfileViewModel.shared.profile!.floor = floorLabel.text ?? ""
        ProfileViewModel.shared.profile!.intercom = intercomLabel.text ?? ""
        ProfileViewModel.shared.profile?.commentsForACourier = commentsForACourierLabel.text ?? ""
        ProfileViewModel.shared.profile?.name = fullnameLabel.text ?? ""
        ProfileViewModel.shared.profile!.phone = phoneUserLabel.text ?? ""
    }
    func setUpLabels() {
        countryLabel.text = ProfileViewModel.shared.profile?.country
        cityLabel.text = ProfileViewModel.shared.profile?.city
        streetLabel.text = ProfileViewModel.shared.profile?.street
        numberHouseLabel.text = String(ProfileViewModel.shared.profile!.numberHouse)
        indexLabel.text = ProfileViewModel.shared.profile?.index
        flatOrOfficeNmumberLabel.text = String(ProfileViewModel.shared.profile!.flatOrOfficeNmumber)
        porchLabel.text = String(ProfileViewModel.shared.profile!.porch)
        floorLabel.text =  String(ProfileViewModel.shared.profile!.floor)
        intercomLabel.text =  String(ProfileViewModel.shared.profile!.intercom)
        commentsForACourierLabel.text = ProfileViewModel.shared.profile?.commentsForACourier
        fullnameLabel.text = ProfileViewModel.shared.profile?.name
        phoneUserLabel.text =  String(ProfileViewModel.shared.profile!.phone)
    }
    func setUpDelegate() {
        countryLabel.delegate = self
        cityLabel.delegate = self
        streetLabel.delegate = self
        numberHouseLabel.delegate = self
        indexLabel.delegate = self
        flatOrOfficeNmumberLabel.delegate = self
        porchLabel.delegate = self
        floorLabel.delegate = self
        intercomLabel.delegate = self
        commentsForACourierLabel.delegate = self
        fullnameLabel.delegate = self
        phoneUserLabel.delegate = self
    }
}

extension DeliveryInfoViewController : UITextFieldDelegate {
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
