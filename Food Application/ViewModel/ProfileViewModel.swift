//
//  ProfileViewModel.swift
//  Food Application
//
//  Created by Admin on 12.06.2022.
//

import Foundation
import UIKit

class ProfileViewModel {
    //static let  shared = ProfileViewModel(profile: profile!)
    static var profile:FirebaseUser?
    static var orders:[Order] = []
    static var imageProfile:UIImage?
    init(profile:FirebaseUser) {
        ProfileViewModel.profile = profile
    }
   static func getOrders() {
       
       // let dispatchGroup2 = DispatchGroup()
      // dispatchGroup2.enter()
      // DispatchQueue.global(qos: .userInteractive).async {
           DataBaseService.shared.getOrders(by: AuthService.shared.currentUser?.accessibilityHint) { result in // 3
                switch result {
                case .success(let orders):
                    ProfileViewModel.orders = orders
                    //kmlmlmlm
                    for (index,order) in self.orders.enumerated() {
    
                       // dispatchGroup.enter()
                        DataBaseService.shared.getPositions(by: order.id) { result in
                            switch result {
                            case .success(let positions):
                                self.orders[index].positions = positions
                                print("getOrders is good  almost finished:\(self.orders[index].cost)")// here is the codez
                           //     dispatchGroup.leave()
                            case .failure(let error):
                                print("getOrders  almost finished:")
                                print(error.localizedDescription)
                             //   dispatchGroup.leave()
                            }
                        }
                        
                    }
                   // dispatchGroup.leave()
                case .failure(let error):
                    print("getOrders is finished almost finished:")
                    print(error.localizedDescription)
                   // dispatchGroup.leave()
                }
            }
          // dispatchGroup2.leave()
       //}
       
       
      //
       //dispatchGroup2.wait()
       print("getOrders is finished")
      // NotificationCenter.default.post(name: NSNotification.Name("order"), object: nil)
      // print("orders")
    }
    static func getProfileImage() {
        //let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
       // let dispatchGroup = DispatchGroup()
        print("urlString = ProfileViewModel.profile?.profileImage = \(String(describing: ProfileViewModel.profile?.profileImage))")
        guard let urlString = ProfileViewModel.profile?.profileImage, let url = URL(string: urlString) else {
            print("no url")
            return
        }
        //dispatchGroup.enter()
        URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                print("error in a data or error")
                return
            }
            let image = UIImage(data: data)
            ProfileViewModel.imageProfile = image
            print("getProfileImage almost finished")
                //./   dispatchGroup.leave()
        }.resume()
        //dispatchGroup.wait()
        print("getProfileImage finished")
        //NotificationCenter.default.post(name: NSNotification.Name("getImage"), object: nil)
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
       
       let queue = DispatchQueue(label: "queue")
       queue.sync {
           DataBaseService.shared.getUser { result in//2
               switch result {
               case .success(let user):
                   print("user:\(user.address)|\(user.name)|\(user.phone)|\(user.profileImage)")
                   
                   ProfileViewModel.profile = user
                   ProfileViewModel.getProfileImage()
               case .failure(let error):
                   print("Error:\(error.localizedDescription)")
               }
           }
       }
        
         
    }
    
    
    
    
    
}
