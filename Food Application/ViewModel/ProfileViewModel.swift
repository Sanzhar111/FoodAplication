//
//  ProfileViewModel.swift
//  Food Application
//
//  Created by Admin on 12.06.2022.
//

import Foundation

class ProfileViewModel {
    //static let  shared = ProfileViewModel(profile: profile!)
    static var profile:FirebaseUser?
    static var orders:[Order] = []
    init(profile:FirebaseUser) {
        ProfileViewModel.profile = profile
    }
   static func getOrders() {
        DataBaseService.shared.getOrders(by: AuthService.shared.currentUser?.accessibilityHint) { result in // 1
            switch result {
            case .success(let orders):
                ProfileViewModel.orders = orders
                //kmlmlmlm
                for (index,order) in self.orders.enumerated() {
                    DataBaseService.shared.getPositions(by: order.id) { result in
                        switch result {
                        case .success(let positions):
                            self.orders[index].positions = positions
                            print("position wergw e:\(self.orders[index].cost)")// here is the code
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("order"), object: nil)
                print("orders")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getPositions () {
        
    }
    static func setProfile() {
        DataBaseService.shared.setUser(user: ProfileViewModel.profile!) { result in
            switch result {
            case .success(let user):
                print("user:\(user.address)|\(user.name)\(user.phone)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
   static func getProfile() {
        DataBaseService.shared.getUser { result in
            switch result {
            case .success(let user):
                print("user:\(user.address)|\(user.name)\(user.phone)")
                ProfileViewModel.profile = user
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
         
    }
    
    
    
    
    
    
}
