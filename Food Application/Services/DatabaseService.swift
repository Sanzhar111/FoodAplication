//
//  DatabaseService.swift
//  Food Application
//
//  Created by Admin on 11.06.2022.
//

import Foundation
import FirebaseFirestore

class DataBaseService {
    static let shared = DataBaseService()
    private let dataBase = Firestore.firestore() // ссылка на папку с базой данных находящаяся в firebase
    private var  usersRef:CollectionReference {
        return dataBase.collection("users")
    } // ссылка на коллекцию пользователей , или же ссылка по которой мы обращаемся к коллекции пользователей
    private var ordersRef:CollectionReference {
        return dataBase.collection("orders")
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
        usersRef.document(AuthService.shared.currentUser!.uid).getDocument { docSnapShot, error in
            guard let snap = docSnapShot else { return }
            guard let data = snap.data() else { return }
            guard let username = data["name"] as? String else { return }
            guard let id = data["id"] as? String? else { return }
            guard let phone = data["phone"] as? Int else { return }
            guard let address = data["address"] as? String else { return }
            let user = FirebaseUser(id: id!, name: username, phone: phone, address: address)
            print("пришедший юзер: \(user.name) | \(user.phone) | \(user.address)")
            complition(.success(user))
        }
    }
    
    func setOrder(order:Order,complition:@escaping(Result<Order,Error>) -> () ) {
        ordersRef.document(order.id).setData(order.representation) {[weak self] error in//создается коллекция c  названием orders и уже в ней id заказа с информацией //
            // создается заказ со всеми данными начиная от позиций, заканчивая id заказчика
            if let  error = error {
                complition(.failure(error))
            } else {
                self?.setPositions(to: order.id, positions: order.positions) {  result in
                    switch result {
                    case .success(let positions):
                        print("positions:\(positions.count)")
                        complition(.success(order))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    func setPositions(to orderId:String,
                     positions:[Position],compelition:@escaping(Result<[Position],Error>) -> () ) {
        let positionRef = ordersRef.document(orderId).collection("positions")//создаем коллекцию position по orderId
        
        for position in positions {
            positionRef.document(position.id).setData(position.representation)//  создается коллекция с именем positions и уже в ней id  позиции с информацией
        }
        compelition(.success(positions))
    }
    func getPositions(by orderId:String,completion:@escaping(Result<[Position],Error>)->()) {
        let positionRef = ordersRef.document(orderId).collection("positions")
        positionRef.getDocuments { qSnapshot, error in
            if let querySnapshot = qSnapshot {
                var positions = [Position]()
                for doc in querySnapshot.documents {
                    if let position = Position(doc: doc) {
                        positions.append(position)
                    }
                }
                completion(.success(positions))
            } else if let error = error {
                //print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    func getOrders(by userId:String?,completion:@escaping(Result<[Order],Error>)->()) {
        //string optional потому что админ будет пользоваться данной функцией
        // если будет передаваться nil то будут передаваться все заказы из базы, если не nil то мы ищем данного юзера и достаем заказы
        ordersRef.getDocuments { qSnapShot, error in
            
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
                completion(.success(orders))
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        
        
    }
}
