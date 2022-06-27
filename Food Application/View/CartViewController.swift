//
//  TrashViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//

import UIKit

class CartViewController: UIViewController {
    
    //var viewModel = CartViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceForAllLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PositionCollectionViewCell", bundle: nil), forCellReuseIdentifier: "PositionCollectionViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if CartViewModel.shared.positions.count == 0 {
            priceForAllLabel.text = "0₽"
        } else {
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            //viewModel.costForAll
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInformation), name: NSNotification.Name("load"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProfileViewModel.getOrders()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProfileViewModel.getOrders()
    }
    
    
    @objc func reloadInformation() {
        self.tableView.reloadData()
        priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
    }
    @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        if CartViewModel.shared.cartPositions.count == 0 {
            let alertContoller = UIAlertController(title:"Невозможно выполнить действие.", message: "Ваша корзина пуста.", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Закрыть", style: .default)
            alertContoller.addAction(alerAction)
            self.present(alertContoller, animated: true)
        } else {
            var order = Order(userId: AuthService.shared.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue)
            order.positions = CartViewModel.shared.cartPositions
            CartViewModel.shared.cartPositions.removeAll()
            priceForAllLabel.text = "0₽"
            tableView.reloadData()
            print("order.positions:\(order.positions)")
            //  ProfileViewModel.orders = CartViewModel.shared.positions wegwegwert wsrthwrrt wrh
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInteractive).async {
                DataBaseService.shared.setOrder(order: order) { result in
                    switch result {
                    case .success(let order):
                        print("orders:\(order.cost)")
                        ProfileViewModel.getOrders()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
            print("continiue working")
            //ProfileViewModel.getOrders()
            //NotificationCenter.default.post(name: NSNotification.Name("order"), object: nil)
        }
    }
    @IBAction func cleanButtonIsTapped(_ sender: Any) {
        if CartViewModel.shared.cartPositions.count == 0 {
            let alertContoller = UIAlertController(title:"Невозможно выполнить действие.", message: "Ваша корзина пуста.", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Закрыть", style: .default)
            alertContoller.addAction(alerAction)
            self.present(alertContoller, animated: true)
        } else {
            CartViewModel.shared.cartPositions.removeAll()
            priceForAllLabel.text = "0₽"
            tableView.reloadData()
        }
    }
}
extension CartViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (CartViewModel.shared.positions.count == 0)  {
            return 0
        } else {
            return CartViewModel.shared.cartPositions.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionCollectionViewCell", for: indexPath) as! PositionCollectionViewCell
        cell.setup(position: CartViewModel.shared.cartPositions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            print("Было: \(CartViewModel.shared.positions.count)")
            CartViewModel.shared.cartPositions.remove(at: indexPath.row)
            //    CartViewModel.shared.positions.removeAll { pos in
            //        pos.product.title == posit
            //   }
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Стало: \(CartViewModel.shared.cartPositions.count)")
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.endUpdates()
        }
    }
    
}
