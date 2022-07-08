//
//  ViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//
import UIKit
class AuthorizationViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.delegate = self
        passwordLabel.delegate = self
    }
    @IBAction func AuthorisationTapped(_ sender: Any) {
        AuthService.shared.signIn(email: emailLabel.text ?? "", password: passwordLabel.text ?? "") { [self] result in 
            switch result {
            case .success(let user):
                self.emailLabel.text = ""
                self.passwordLabel.text = ""
                ProfileViewModel.shared.getProfile()
                ProfileViewModel.shared.getOrders()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TabbarController") as! MainTabBarViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            case .failure(let error):
                showError(errorText: "Ошибка авторизации: \(error.localizedDescription)")
            }
        }
    } 
    @IBAction func showRegistrationVC(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let newVC = story.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: false)
    }
    func showError (errorText:String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alerAction)
        present(alertController, animated: true)
    }
}
extension AuthorizationViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailLabel {
            emailLabel.resignFirstResponder()
        } else {
            passwordLabel.resignFirstResponder()
        }
        return true
    }
}
