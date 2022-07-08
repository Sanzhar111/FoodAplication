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
    init() {
    }
    func getPopularOrders(completion:@escaping(Result<[Productt],Error>)->()) {
        DataBaseService.shared.getPopularProducts { result in
            switch result {
            case .success(let products):
                self.products.popular = products
                DispatchQueue.main.async {
                    completion(.success(products))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    func getProductImage(index:Int,completion:@escaping (Result<UIImage,Error>)->()) {
        guard let urlString = self.products.popular[index].imageURL , let url = URL(string: urlString) else {
             print("no url")
            return
        }
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
        }.resume()
    }
}
