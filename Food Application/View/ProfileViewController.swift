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
    @IBOutlet weak var exitButton: UIButton!
    let button = UIButton(type: .custom)
    let button2 = UIButton(type: .custom)
    let button3 = UIButton(type: .custom)
    var isClickable = false
    var maxnumberCount = 11
    private let navigationManager = NavigationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        
        nameTextField.delegate = self
        numberTextField.delegate = self
        addressTextField.delegate = self
        
        nameTextField.text = ProfileViewModel.shared.profile?.name
        if String(ProfileViewModel.shared.profile!.phone) == "0" {
            numberTextField.text = ""
        } else {
            numberTextField.text = String(ProfileViewModel.shared.profile!.phone)
        }
        
        addressTextField.text = ProfileViewModel.shared.profile?.address
        
        numberTextField.keyboardType = .numbersAndPunctuation
        
        setButton(button: button, tag: 1, textField: nameTextField)
        setButton(button: button2, tag: 2, textField: numberTextField)
        setButton(button: button3, tag: 3, textField: addressTextField)
        Utilities.styleFilledButton(exitButton)
        profilePhotoImageView.layer.cornerRadius = 5
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePhotoImageView.image = ProfileViewModel.shared.imageProfile
        self.ordersTableView.reloadData()
    }
    @objc func reloadImage() {
        profilePhotoImageView.image = ProfileViewModel.shared.imageProfile
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
            do {
                try AuthService.shared.auth.signOut()
            } catch let error as NSError {
                print("Fail: \(error.localizedDescription)")
            } catch {
                print("Fail: \(error)")
            }
            ProfileViewModel.shared.orders.removeAll()
            ProfileViewModel.shared.imageProfile = nil
            self.showInitialScreen()
        }
        let action2 = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true)
    }
     func showInitialScreen() {
        if AuthService.shared.auth.currentUser != nil {
            navigationManager.show(screen: .mainApp, inController: self)
        } else {
            navigationManager.show(screen: .onboarding, inController: self)
        }
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
        print( ProfileViewModel.shared.orders.count)
        return ProfileViewModel.shared.orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.setup(order: ProfileViewModel.shared.orders[indexPath.row])
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
            ProfileViewModel.shared.profile!.name = nameTextField.text!
            ProfileViewModel.shared.setProfile()
            isClickable = false
        } else if textField == numberTextField {
            numberTextField.resignFirstResponder()
            ProfileViewModel.shared.profile!.phone = Int(numberTextField.text ?? "0") ?? 0
            ProfileViewModel.shared.setProfile()
            isClickable = false
        } else {
            ProfileViewModel.shared.profile?.address = addressTextField.text!
            ProfileViewModel.shared.setProfile()
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
                DispatchQueue.main.async { 
                    self.profilePhotoImageView.image = image
                    DataBaseService.shared.uploadImage(currentUserID: AuthService.shared.auth.currentUser!.uid, photo: self.profilePhotoImageView.image!) { res in
                        switch res {
                        case .success(let url):
                            let urtString = url.absoluteString
                            ProfileViewModel.shared.profile?.profileImage = urtString
                            ProfileViewModel.shared.setProfile()
                            print("the url:\(urtString)")
                        case .failure(let error):
                            print("error is exactly here")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.profilePhotoImageView.image = image
            ProfileViewModel.shared.imageProfile = image
            DataBaseService.shared.uploadImage(currentUserID: AuthService.shared.auth.currentUser!.uid, photo: self.profilePhotoImageView.image!) { res in
                switch res {
                case .success(let url):
                    let urtString = url.absoluteString
                    print("ursString = \(urtString)")
                    ProfileViewModel.shared.profile?.profileImage = urtString
                    print("Here is ProfileViewModel.profile?.profileImage = \(String(describing: ProfileViewModel.shared.profile?.profileImage)) ")
                    ProfileViewModel.shared.setProfile()
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
