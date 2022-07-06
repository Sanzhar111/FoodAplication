//
//  CathalogViewModel.swift
//  Food Application
//
//  Created by Admin on 30.06.2022.
//
import UIKit
import Foundation
import Firebase
class CathalogViewModel {
    var products = Menu()
    //private let dispatchGroup = DispatchGroup()
    init() {
        //getPopularOrders()
    }
    func getPopularOrders(completion:@escaping(Result<[Productt],Error>)->()) {
        //dispatchGroup.enter()
        DataBaseService.shared.getPopularProducts { result in
            switch result {
            case .success(let products):
            //    self.dispatchGroup.enter()
                self.products.popular = products
            //    NotificationCenter.default.post(name: NSNotification.Name("cathalog"), object: nil)              //  self.dispatchGroup.leave()
                DispatchQueue.main.async {
                    completion(.success(products))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        //dispatchGroup.wait()
        print("dispatchGroup.wait()")
    }
    func getProductImage(index:Int,completion:@escaping (Result<UIImage,Error>)->()) {
        //let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
       // let dispatchGroup = DispatchGroup()
//        print("urlString = ProfileViewModel.profile?.profileImage = \(String(describing: ProfileViewModel.profile?.profileImage))")
        defer {
            
        }
        guard let urlString = self.products.popular[index].imageURL , let url = URL(string: urlString) else {
             print("no url")
            return
        }
        //dispatchGroup.enter()
        URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                print("error in a data or error")
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(error!))
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
            
            // self.products.popular[index].image = image
            //ProfileViewModel.imageProfile = image
            print("+++++++++++getProfileImage almost finished+++++++++++++=+++")
                //./   dispatchGroup.leave()
        }.resume()
        //dispatchGroup.wait()
        print("getProfileImage finished")
        //NotificationCenter.default.post(name: NSNotification.Name("getImage"), object: nil)
    }
}
