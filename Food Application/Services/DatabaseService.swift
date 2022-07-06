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
    private let dataBase = Firestore.firestore() // ссылка на папку с базой данных находящаяся в firebase
    private var storage = Storage.storage()
    private var  usersRef:CollectionReference {
        return dataBase.collection("users")
    } // ссылка на коллекцию пользователей , или же ссылка по которой мы обращаемся к коллекции пользователей
    private var ordersRef:CollectionReference {
        return dataBase.collection("orders")
    }
    private var imageRef:StorageReference {
        return storage.reference(forURL: "gs://pizzashop-4af9d.appspot.com/").child("avatars")
    //
    }
    
    private var popularRef:CollectionReference {
        return dataBase.collection("Popular")
    }
    
    private init () {}
    func setUser(user:FirebaseUser, complition: @escaping (Result<FirebaseUser,Error>) -> () ) {//функция для записи юзера в базу данных // или же иначе говоря создание юзера в базе данных
        usersRef.document(user.id).setData(user.representation) { error in //делаем что-то с данными которые пришли с сервера
            //там далеко на серваке выолняется что-то
            //и вскорее всего там есть только ошибка
            // и если эта ошибка равна nil значит все ок
            // посылаются данные
            //1
            //делаем что-то с данными которые пришли и если ошибки нет то возвращается success и данные с сервера
            if let error = error {// в случае успеха вызывается failure  и данные
                complition(.failure(error))
            } else { // иначе вызывается success и определенные данные 
                complition(.success(user))
            }
        }
    }
    func getUser(complition: @escaping (Result<FirebaseUser,Error>) -> () ) {
        usersRef.document(AuthService.shared.currentUser!.uid).getDocument { docSnapShot, error in // (2) true calling
            guard let snap = docSnapShot else { return }
            guard let data = snap.data() else { return }
            guard let username = data["name"] as? String else { return }
            guard let id = data["id"] as? String? else { return }
            guard let phone = data["phone"] as? Int else { return }
            guard let address = data["address"] as? String else { return }
            guard let profileImage = data["profileImage"] as? String else { return }
            let user = FirebaseUser(id: id!, name: username, phone: phone, address: address, profileImage: profileImage)
            print("пришедший юзер: \(user.name) | \(user.phone) | \(user.address)")
            complition(.success(user)) // пришел ответ
        }
    }
    
    func setOrder(order:Order,
                  complition:@escaping(Result<Order,Error>) -> ()) {
        ordersRef.document(order.id).setData(order.representation) {[weak self] error in//создается коллекция c  названием orders и уже в ней id заказа с информацией //
            // создается ордер id  и туда инфомарция связанная с заказом
            // создается заказ со всеми данными начиная от позиций, заканчивая id заказчика
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
        let positionRef = ordersRef.document(orderId).collection("positions")//создаем коллекцию position по orderId
        // в заказе создается коллекция positions
        for position in positions {
            positionRef.document(position.id).setData(position.representation)//  создается коллекция с именем positions и уже в ней id  позиции с информацией
        }
        DispatchQueue.main.async {
            compelition(.success(positions))
        }
        
    }
    func getPositions(by orderId:String,
                      completion:@escaping(Result<[Position],Error>)->()) {
        let positionRef = ordersRef.document(orderId).collection("positions")
        positionRef.getDocuments { qSnapshot, error in // 4
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
                //print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func getPopularProducts(completion:@escaping(Result<[Productt],Error>)->()) {
        popularRef.getDocuments { qSnapShot, error in
            if let qSnapShot = qSnapShot {
                var popularProducts = [Productt]()
                for doc in qSnapShot.documents {
                 //   popularProducts.i
                    if let popularProduct = Productt(doc: doc) {
                        print("popularProduct.title = \(popularProduct.title)")
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
        //string optional потому что админ будет пользоваться данной функцией
        // если будет передаваться nil то будут передаваться все заказы из базы, если не nil то мы ищем данного юзера и достаем заказы
        print("DataBaseService.shared.getOrders(by: AuthService.shared.currentUser!.uid) = \(AuthService.shared.currentUser!.uid)")
        ordersRef.getDocuments { qSnapShot, error in //(3) true calling
            
            if let qSnapShot = qSnapShot {
                var orders = [Order]()
                for doc in qSnapShot.documents {
                    if let userId = userId { // если userId получен то мы добавляем тлько те заказы которые соответствутют ётому userId
                        if let order = Order(doc: doc),order.userId == userId {
                            orders.append(order)
                        }
                    } else {//иначе добавляем все заказы которые есть в базе
                        //ветка Админа
                        if let order = Order(doc: doc) {
                            orders.append(order)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(orders))
                }
                 // вернулся ответ
                // 3-1 вернулся ответ
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        
        
    }
    func uploadImage(currentUserID:String,photo:UIImage,completion:@escaping(Result<URL,Error>)->()) {
        let imageReference = storage.reference().child("avatars").child(AuthService.shared.currentUser!.uid)
        //imageRef.child(currentUserID)
        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageReference.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                print("print here")
                completion(.failure(error!))
                return
            }
            imageReference.downloadURL { url, error in
                guard let url = url else {
                    print("and print  smth here")
                    completion(.failure(error!))
                    return
                }
                //print("")
                DispatchQueue.main.async {
                    completion(.success(url))
                }
            }
        }
    }
}
