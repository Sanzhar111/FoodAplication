//
//  TrashViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
   // @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceForAllLabel: UILabel!
    @IBOutlet weak var cleanButton: UIBarButtonItem!
    @IBOutlet weak var orderButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.collectionView.register(UINib(nibName: "ProductListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductListCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        if CartViewModel.shared.positions.count == 0 {
            priceForAllLabel.text = "0₽"
        } else {
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInformation), name: NSNotification.Name("load"), object: nil)
      //  Utilities.styleFilledButton(cleanButton)
        Utilities.styleFilledButton(orderButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProfileViewModel.shared.getOrders()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProfileViewModel.shared.getOrders()
    }
    
    @objc func reloadInformation() {
        self.collectionView.reloadData()
         priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
    }
    @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        if CartViewModel.shared.cartPositions.count == 0 {
            let alertContoller = UIAlertController(title:"Невозможно выполнить действие.", message: "Ваша корзина пуста.", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Закрыть", style: .default)
            alertContoller.addAction(alerAction)
            self.present(alertContoller, animated: true)
        } else {
            var order = Order(userId: AuthService.shared.auth.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue)
            order.positions = CartViewModel.shared.cartPositions
            CartViewModel.shared.cartPositions.removeAll()
            priceForAllLabel.text = "0₽"
            collectionView.reloadData()
            print("order.positions:\(order.positions)")
                DataBaseService.shared.setOrder(order: order) { result in
                    switch result {
                    case .success(let order):
                        print("orders:\(order.cost)")
                        ProfileViewModel.shared.getOrders()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
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
            collectionView.reloadData()
        }
    }
}
extension CartViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartViewModel.shared.cartPositions.count

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        cell.setup(position: CartViewModel.shared.cartPositions[indexPath.item])
      //  CartViewModel.shared.positions
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // height += 90
        return CGSize(width: (self.view.bounds.width - 2 ) , height: 100)
    }

    
   /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (CartViewModel.shared.positions.count == 0)  {
            return 0
        } else {
            return CartViewModel.shared.cartPositions.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        //cell.setup(position: CartViewModel.shared.cartPositions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            print("Было: \(CartViewModel.shared.positions.count)")
            CartViewModel.shared.cartPositions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Стало: \(CartViewModel.shared.cartPositions.count)")
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.endUpdates()
        }
    }*/
}
