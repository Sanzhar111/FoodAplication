//
//  CathalogViewModel.swift
//  Food Application
//
//  Created by Admin on 30.06.2022.
//

import Foundation
import Firebase
class CathalogViewModel {
    var products = Menu()
    private let dispatchGroup = DispatchGroup()
    init() {
        getPopularOrders()
    }
    func getPopularOrders() {
        //dispatchGroup.enter()
        DataBaseService.shared.getPopularProducts { result in
            switch result {
            case .success(let products):
            //    self.dispatchGroup.enter()
                self.products.popular = products
                NotificationCenter.default.post(name: NSNotification.Name("cathalog"), object: nil)              //  self.dispatchGroup.leave()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        //dispatchGroup.wait()
        print("dispatchGroup.wait()")
    }
}
