//
//  ProfileViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//

import UIKit
import Photos
import PhotosUI
class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    let button = UIButton(type: .custom)
    let button2 = UIButton(type: .custom)
    let button3 = UIButton(type: .custom)
    var isClickable = false
    var maxnumberCount = 11
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        
        nameTextField.delegate = self
        numberTextField.delegate = self
        addressTextField.delegate = self
        
        nameTextField.text = ProfileViewModel.profile?.name
        numberTextField.text = String(ProfileViewModel.profile!.phone)
        addressTextField.text = ProfileViewModel.profile?.address
        
        numberTextField.keyboardType = .numbersAndPunctuation
        
        setButton(button: button, tag: 1, textField: nameTextField)
        setButton(button: button2, tag: 2, textField: numberTextField)
        setButton(button: button3, tag: 3, textField: addressTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInformation), name: NSNotification.Name("order"), object: nil)
        // getImage
        NotificationCenter.default.addObserver(self, selector: #selector(reloadImage), name: NSNotification.Name("getImage"), object: nil)
    }
    @objc func reloadImage() {
        profilePhotoImageView.image = ProfileViewModel.imageProfile
    }
    @objc func reloadInformation() {
        self.ordersTableView.reloadData()
    }
    func setButton(button:UIButton,tag:Int,textField:UITextField) {
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(textField.frame.size.height))
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.tag = tag
        textField.rightView = button
        textField.rightViewMode = .always
    }
    @objc func tapped(responder:UIButton) {
        print("i tapped")
        isClickable = true
        if responder.tag == 1 {
            nameTextField.becomeFirstResponder()
        } else if responder.tag == 2 {
            numberTextField.becomeFirstResponder()
        } else {
            addressTextField.becomeFirstResponder()
        }
    }
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        print("Exit")
        let alert = UIAlertController(title: "Вы действительно хотите выйти?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default) { action in
            self.dismiss(animated: true)
        }
        let action2 = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true)
    }
    @IBAction func setImageButtonIsTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Выбрать фото", style: .default) { [weak self]action in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 3
            config.filter = .images
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        let action2  = UIAlertAction(title: "Сделать фото", style: .default) {  action in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
        let action3 = UIAlertAction(title: "отмена", style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        present(alertController, animated: true)
    }
}
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print( ProfileViewModel.orders.count)
        return ProfileViewModel.orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.setup(order: ProfileViewModel.orders[indexPath.row])
        return cell
    }
}
extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            return isClickable
        } else if textField == numberTextField  {
            return isClickable
        } else if textField == addressTextField {
            return isClickable
        } else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nameTextField.resignFirstResponder()
            print("the text is : \(String(describing: nameTextField.text))")
            ProfileViewModel.profile!.name = nameTextField.text!
            ProfileViewModel.setProfile()
            isClickable = false
        } else if textField == numberTextField {
            numberTextField.resignFirstResponder()
            ProfileViewModel.profile!.phone = Int(numberTextField.text ?? "0") ?? 0 // wqfqefnnlqeknlkqjwnlkqnlkqnglk
            ProfileViewModel.setProfile()
            isClickable = false
        } else {
            ProfileViewModel.profile?.address = addressTextField.text!
            ProfileViewModel.setProfile()
            addressTextField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            let allowedCharacters = "1234567890"
            let alloweCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return alloweCharacterSet.isSuperset(of: typedCharacterSet)
        }  else {
            return true
        }
    }
}
extension ProfileViewController:PHPickerViewControllerDelegate {
    // photo from library
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                DispatchQueue.main.async {//*
                    self.profilePhotoImageView.image = image
                    DataBaseService.shared.uploadImage(currentUserID: AuthService.shared.currentUser!.uid, photo: self.profilePhotoImageView.image!) { res in
                        switch res {
                        case .success(let url):
                            let urtString = url.absoluteString
                            ProfileViewModel.profile?.profileImage = urtString
                            ProfileViewModel.setProfile()
                            print("the url:\(urtString)")
                        case .failure(let error):
                            print("error is exactly here")
                            print(error.localizedDescription)
                        }
                    }
                }//*
            }
        }
    }
}
extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhotoImageView.image = image
            DataBaseService.shared.uploadImage(currentUserID: AuthService.shared.currentUser!.uid, photo: self.profilePhotoImageView.image!) { res in
                switch res {
                case .success(let url):
                    let urtString = url.absoluteString
                    ProfileViewModel.profile?.profileImage = urtString
                    ProfileViewModel.setProfile()
                    print("the url:\(urtString)")
                case .failure(let error):
                    print("error is exactly here")
                    print(error.localizedDescription)
                }
            }
        } else { return}
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
