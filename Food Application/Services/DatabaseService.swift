//
//  DatabaseService.swift
//  Food Application
//
//  Created by Admin on 11.06.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class DataBaseService {
    static let shared = DataBaseService()
    private let dataBase = Firestore.firestore()
    private var storage = Storage.storage()
    private var  usersRef:CollectionReference {
        return dataBase.collection("users")
    }
    private var ordersRef:CollectionReference {
        return dataBase.collection("orders")
    }
    private var imageRef:StorageReference {
        return storage.reference(forURL: "gs://pizzashop-4af9d.appspot.com/").child("avatars")
    }
    private var popularRef:CollectionReference {
        return dataBase.collection("Popular")
    }
    private init () {}
    func setUser(user:FirebaseUser, complition: @escaping (Result<FirebaseUser,Error>) -> () ) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                complition(.failure(error))
            } else {
                complition(.success(user))
            }
        }
    }
    func getUser(complition: @escaping (Result<FirebaseUser,Error>) -> () ) {
        usersRef.document(AuthService.shared.auth.currentUser!.uid).getDocument { docSnapShot, error in
            guard let snap = docSnapShot else { return }
            guard let data = snap.data() else { return }
            guard let username = data["name"] as? String else { return }
            guard let id = data["id"] as? String? else { return }
            guard let phone = data["phone"] as? Int else { return }
            guard let address = data["address"] as? String else { return }
            guard let profileImage = data["profileImage"] as? String else { return }
            let user = FirebaseUser(id: id!, name: username, phone: phone, address: address, profileImage: profileImage)
            print("пришедший юзер: \(user.name) | \(user.phone) | \(user.address)")
            complition(.success(user))
        }
    }
    func setOrder(order:Order,
                  complition:@escaping(Result<Order,Error>) -> ()) {
        ordersRef.document(order.id).setData(order.representation) {[weak self] error in
            if let  error = error {
                complition(.failure(error))
            } else {
                self?.setPositions(to: order.id, positions: order.positions) { result in
                    switch result {
                    case .success(let positions):
                        print("positions:\(positions.count)")
                        DispatchQueue.main.async {
                            complition(.success(order))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func setPositions(to orderId:String,
                      positions:[Position],
                      compelition:@escaping(Result<[Position],Error>) -> () ) {
        let positionRef = ordersRef.document(orderId).collection("positions")
        for position in positions {
            positionRef.document(position.id).setData(position.representation)
        }
        DispatchQueue.main.async {
            compelition(.success(positions))
        }
    }
    func getPositions(by orderId:String,
                      completion:@escaping(Result<[Position],Error>)->()) {
        let positionRef = ordersRef.document(orderId).collection("positions")
        positionRef.getDocuments { qSnapshot, error in
            if let querySnapshot = qSnapshot {
                var positions = [Position]()
                for doc in querySnapshot.documents {
                    if let position = Position(doc: doc) {
                        positions.append(position)
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(positions))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func getPopularProducts(completion:@escaping(Result<[Productt],Error>)->()) {
        popularRef.getDocuments { qSnapShot, error in
            if let qSnapShot = qSnapShot {
                var popularProducts = [Productt]()
                for doc in qSnapShot.documents {
                    if let popularProduct = Productt(doc: doc) {
                        popularProducts.append(popularProduct)
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(popularProducts))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func getOrders(by userId:String?,completion:@escaping(Result<[Order],Error>)->()) {
        ordersRef.getDocuments { qSnapShot, error in
            if let qSnapShot = qSnapShot {
                var orders = [Order]()
                for doc in qSnapShot.documents {
                    if let userId = userId {
                        if let order = Order(doc: doc),order.userId == userId {
                            orders.append(order)
                        }
                    } else {
                        //ветка Админа
                        if let order = Order(doc: doc) {
                            orders.append(order)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(orders))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func uploadImage(currentUserID:String,photo:UIImage,completion:@escaping(Result<URL,Error>)->()) {
        let imageReference = storage.reference().child("avatars").child(AuthService.shared.auth.currentUser!.uid)
        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageReference.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            imageReference.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(url))
                }
            }
        }
    }
}
