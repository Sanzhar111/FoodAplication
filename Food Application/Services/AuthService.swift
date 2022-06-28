//
//  AuthService.swift
//  Food Application
//
//  Created by Admin on 10.06.2022.
//

import Foundation
import FirebaseAuth

class AuthService {
    //singlton
    static let shared = AuthService()
    private init() {}// приватный инициализатор гарантирует
    //то что не будет создан
    // еще один AuthService
    private let auth = Auth.auth()// хранит ссылку на таблиуц с юзерами
   
    // если юзер есть то он вернетсч иначе nil
    //вычисление производится в свойстве ниже
    var currentUser:User? {
        return auth.currentUser
    }// user exist or it can be nil when he sign up
    
    
    
    // выполняется како-то десвтиве там в далеке на сревре
    // и если все хорошо то приходит определенныый ответ то есть иначе говоря result
    // в противном случае кода прорзошла какая-то ошибка прихдит error
    //потом поисходят действия в данном файле или иначе говоря блоков кода которые находятся внизу
    //
    
    //
    //вызыветс
    func signUp(email:String,password:String,completion:@escaping(Result<User,Error>)->()) {// регистрация пользователя
        auth.createUser(withEmail: email, password: password) { result, error in//делаем что-то с данными которые пришли  с сервера
            // если все ок выолняется  result
            //в случае успешного ответа выолняется result
            if let result = result {//приходит какой-то ответ из сервера
                /*
                 в данном result
                 делаем что-то с данными которые пришли с сервера
                 */
                let firebaseUser = FirebaseUser(id: result.user.uid, name: "", phone: 0, address: "", profileImage: "")//создаем юзера который только что зарегистрировался
                
                // если все ок то возвращаем данные с серрвера
                DataBaseService.shared.setUser(user: firebaseUser) { resultDB in // делаем что-то с даныыми которые пришли с сервера 
                    switch resultDB {
                        //2
                        //возвращается чел при успешнов выполнении 
                    case .success(let user): // возвращается suсcess и данные с сервера
                        //ProfileViewModel.profile = firebaseUser
                        ProfileViewModel.getProfile()
                        ProfileViewModel.getOrders()
                        completion(.success(result.user))//юзер который пришел из бвзы хранится по адресу result.user
                        // то есть сгонял в базу данных записался и вернулся в качестве результата

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }//обращаемся по ссылке к таблице
    }
    
    func signIn(email:String,password:String,completion:@escaping(Result<User,Error>)->()) {//авторизация
        auth.signIn(withEmail: email, password: password) { result, error in // (1) true calling
            if let result = result {
                completion(.success(result.user)) // 1-1 после (1) получили ответ
                // 1-2 получили ответ
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
