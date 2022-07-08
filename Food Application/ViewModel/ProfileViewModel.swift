//
//  ProfileViewModel.swift
//  Food Application
//
//  Created by Admin on 12.06.2022.
//
import Foundation
import UIKit
class ProfileViewModel {
    static let  shared = ProfileViewModel()
    var profile:FirebaseUser?
    var orders:[Order] = []
    var imageProfile:UIImage?
    private init() {}
    func getOrders() {
       DataBaseService.shared.getOrders(by: AuthService.shared.auth.currentUser!.uid) { result in // 3
                switch result {
                case .success(let orders):
                    ProfileViewModel.shared.orders = orders
                    for (index,order) in ProfileViewModel.shared.orders.enumerated() {
                        DataBaseService.shared.getPositions(by: order.id) { result in
                            switch result {
                            case .success(let positions):
                                ProfileViewModel.shared.orders[index].positions = positions
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
     func getProfileImage() {
        guard let urlString = ProfileViewModel.shared.profile?.profileImage, let url = URL(string: urlString) else {
            print("no url")
            return
        }
        URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                print("error in a data or error")
                return
            }
            let image = UIImage(data: data)
            ProfileViewModel.shared.imageProfile = image
        }.resume()
    }
     func setProfile() {
        DataBaseService.shared.setUser(user: ProfileViewModel.shared.profile!) { result in
            switch result {
            case .success(let user):
                print("user:\(user.address)|\(user.name)\(user.phone)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getProfile() {
       let queue = DispatchQueue(label: "queue")
       queue.sync {
           DataBaseService.shared.getUser { result in//2
               switch result {
               case .success(let user):
                   print("user:\(user.address)|\(user.name)|\(user.phone)|\(user.profileImage)")
                   ProfileViewModel.shared.profile = user
                   ProfileViewModel.shared.getProfileImage()
               case .failure(let error):
                   print("Error:\(error.localizedDescription)")
               }
           }
       }
    }
}
