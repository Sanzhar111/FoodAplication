//
//  AuthService.swift
//  Food Application
//
//  Created by Admin on 10.06.2022.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}
    let auth = Auth.auth()
    func signUp(email:String,password:String,completion:@escaping(Result<User,Error>)->()) {// регистрация пользователя
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let firebaseUser = FirebaseUser(id: result.user.uid, name: "", phone: "", address: "", profileImage: "", country: "", city: "", street: "", numberHouse: "", index: "", flatOrOfficeNmumber: "", porch: "", floor: "", intercom: "", commentsForACourier: "")
                DataBaseService.shared.setUser(user: firebaseUser) { resultDB in
                    switch resultDB {
                    case .success(let user):
                        ProfileViewModel.shared.getProfile()
                        ProfileViewModel.shared.getOrders()
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func signIn(email:String,password:String,completion:@escaping(Result<User,Error>)->()) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func validateFields(password:String,email:String) -> String? {
        if password.trimmingCharacters(in: .whitespacesAndNewlines) == "" || email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let correctPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidPassword(correctPassword) == false {
            return "Please make sure your password is at least 8 caracters, contains a special character and a number"
        }
        let correctEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(correctEmail) == false {
            return "Please make sure your Email is correct"
        }
        return nil
    }
   private func isValidPassword(_ password:String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
