//
//  RegistrationViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//
import UIKit
class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.delegate = self
        passwordLabel.delegate = self
    }
    @IBAction func registrationTapped(_ sender: Any) {
        let validatifonFields = AuthService.shared.validateFields(password: passwordLabel.text ?? "", email: emailLabel.text ?? "")
        if validatifonFields != nil {
            showError(errorText: validatifonFields!)
        } else {
            AuthService.shared.signUp(email: self.emailLabel.text!, password: self.passwordLabel.text!) { [self] result in 
                switch result {
                case .success(let user):
                    self.emailLabel.text = ""
                    self.passwordLabel.text = ""
                    ProfileViewModel.shared.getProfile()
                    ProfileViewModel.shared.getOrders()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "TabbarController")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                case .failure(let error) : showError(errorText: "Ошибка регистрации \(error.localizedDescription)")
                }
           }
        }
    }
    @IBAction func showAuthorisationVC(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let newVC = story.instantiateViewController(withIdentifier: "AuthorizationViewController") as! AuthorizationViewController
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true, completion: nil)
    }
    func showError (errorText:String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alerAction)
        present(alertController, animated: true)
    }
}
extension RegistrationViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailLabel {
            emailLabel.resignFirstResponder()
        } else {
            passwordLabel.resignFirstResponder()
        }
        return true
    }
}
