//
//  TrashViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceForAllLabel: UILabel!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var viewControllerToInsertBelow : UIViewController?

    
    private var viewHeightVar = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TwoCellsTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoCellsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInformation), name: NSNotification.Name("load"), object: nil)
      //  Utilities.styleFilledButton(cleanButton)
        Utilities.styleFilledButton(orderButton)
        self.navigationController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLabels()
        ProfileViewModel.shared.getOrders()
        tableView.reloadData()
        if CartViewModel.shared.cartPositions.count == 0 {
            moveItemsToBottom(duration: 0)
        }
            
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProfileViewModel.shared.getOrders()
    }
    
    func setUpLabels() {
        if CartViewModel.shared.cartPositions.count == 0 {
            self.tableView.alpha = 0
        } else {
            self.tableView.alpha = 1
            self.emptyLabel.alpha = 0
        }
        if CartViewModel.shared.cartPositions.count == 0 {
            priceForAllLabel.text = "0₽"
        } else {
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
        }
    }
    @objc func reloadInformation() {
        self.tableView.reloadData()
        heightSetup()
         priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
    }
   /* @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        if CartViewModel.shared.cartPositions.count == 0 {
            showDefaultAlertController()
        } else {
            var order = Order(userId: AuthService.shared.auth.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue)
            order.positions = CartViewModel.shared.cartPositions
            CartViewModel.shared.cartPositions.removeAll()
            priceForAllLabel.text = "0₽"
            tableView.reloadData()
            heightSetup()
            self.tableView.alpha = 0
            self.emptyLabel.alpha = 1
            moveItemsToBottom()
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
            let alertContoller = UIAlertController(title:"Заказ успешно совершен", message:"Cпасибо за покупку!" , preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Закрыть", style: .default)
            alertContoller.addAction(alerAction)
            self.present(alertContoller, animated: true)
        }
    }*/
    @IBAction func cleanButtonIsTapped(_ sender: Any) {
        if CartViewModel.shared.cartPositions.count == 0 {
            showDefaultAlertController()
        } else {
            let alertContoller = UIAlertController(title:nil, message: nil , preferredStyle: .actionSheet)
            let alerAction = UIAlertAction(title: "Удалить все", style: .default) { action in
                CartViewModel.shared.cartPositions.removeAll()
                self.priceForAllLabel.text = "0₽"
                self.tableView.reloadData()
                self.moveItemsToBottom(duration: 0.3)
                self.tableView.alpha = 0
                self.emptyLabel.alpha = 1
                self.heightSetup()
            }
            let alerAction2 = UIAlertAction(title: "Удалить выбранные", style: .default) { action in
                CartViewModel.shared.cartPositions = CartViewModel.shared.cartPositions.filter() {$0.isSelected != true }
                print(CartViewModel.shared.cartPositions.count)
                self.priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
                self.emptyLabel.alpha = 0
                self.tableView.reloadData()
                if CartViewModel.shared.cartPositions.count == 0 {
                    self.tableView.alpha = 0
                    self.emptyLabel.alpha = 1
                    self.moveItemsToBottom(duration: 0.3)
                }
                self.heightSetup()
            }
            let alerAction3 = UIAlertAction(title: "Отмена", style: .cancel)
            alertContoller.addAction(alerAction)
            alertContoller.addAction(alerAction2)
            alertContoller.addAction(alerAction3)
            self.present(alertContoller, animated: true)
            
        }
    }
    
    @IBAction func selectAllProduct(_ sender: UIButton) {
        if CartViewModel.shared.cartPositions.count == 0 {
            showDefaultAlertController()
        } else {
            CartViewModel.shared.selectAllPostitions()
            tableView.reloadData()
        }
        
    }
    @IBAction func orderButtonIsTapped(_ sender: UIButton) {
        if CartViewModel.shared.cartPositions.count == 0 {
            showDefaultAlertController()
        } else {
            if ProfileViewModel.shared.profile?.name == "" || ProfileViewModel.shared.profile?.phone == "" ||
                ProfileViewModel.shared.profile?.street == "" ||
                ProfileViewModel.shared.profile?.country == "" ||
                ProfileViewModel.shared.profile?.city == "" {
                //openViewController()vewvrewerbwnowrebnwrijn
                pushTwoViewControllers()
            } else {
               // openViewController()
                showControllersForOrder()
            }
        }
    }
    
    private func heightSetup() {
        self.view.layoutIfNeeded()
        self.tableViewHeight.constant =
        self.tableView.contentSize.height
        self.viewHeightVar = Int(tableViewHeight.constant)
        self.viewHeight.constant = CGFloat(viewHeightVar)
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: CGFloat(viewHeightVar + 150))
       self.view.layoutIfNeeded()
    }
    private func moveItemsToBottom(duration : Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0))) {
            UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                self.orderButton.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - 148
                self.totalLabel.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - 183
                self.priceForAllLabel.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - 183
            },completion: nil)
        }
    }
    private func showDefaultAlertController() {
        let alertContoller = UIAlertController(title:"Невозможно выполнить действие.", message: "Ваша корзина пуста.", preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "Закрыть", style: .default)
        alertContoller.addAction(alerAction)
        self.present(alertContoller, animated: true)
    }
}
extension CartViewController:UITableViewDelegate,UITableViewDataSource,SelectedTableViewCellDelegate{
    func upValue(value: Int, sender: TwoCellsTableViewCell) {
        print("the major value = \(value)")
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            print("is seleceted(=)==\(selectedIndexPath)")
            CartViewModel.shared.cartPositions[selectedIndexPath.row].count = value
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
    }
    func deleteRow(sender: TwoCellsTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            print("is seleceted(=)==\(selectedIndexPath)")
            CartViewModel.shared.cartPositions.remove(at: selectedIndexPath.row)
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.reloadData()
            if CartViewModel.shared.cartPositions.count == 0 {
                moveItemsToBottom(duration: 0.3)
            }
        }
    }
    
    func checkBoxToggle(sender: TwoCellsTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            print("is seleceted(=)==\(selectedIndexPath)")
            CartViewModel.shared.cartPositions[selectedIndexPath.row].isSelected = !CartViewModel.shared.cartPositions[selectedIndexPath.row].isSelected
//            data[selectedIndexPath.row].isChecked = !data[selectedIndexPath.row].isChecked
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCellsTableViewCell", for: indexPath) as! TwoCellsTableViewCell
        cell.position = CartViewModel.shared.cartPositions[indexPath.item]
        cell.delegate = self
        cell.collectionView.reloadData()
        heightSetup()
        print(cell.position.product.title)
        print(cell.position.count)
        print(cell.position.cost)
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            print("Было: \(CartViewModel.shared.cartPositions.count)")
            CartViewModel.shared.cartPositions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Стало: \(CartViewModel.shared.cartPositions.count)")
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print(CartViewModel.shared.cartPositions.count)
        return CartViewModel.shared.cartPositions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension CartViewController:UINavigationControllerDelegate {
    func pushTwoViewControllers() {
        if let viewController2 = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as? ProfileDetailsViewController,
               let viewController3 = self.storyboard?.instantiateViewController(withIdentifier: "InfoForDeliveryViewController") as? InfoForDeliveryViewController { //change this to your identifiers
            viewController3.delegate = viewController2
            self.viewControllerToInsertBelow = viewController2
            self.navigationController?.modalPresentationStyle = .currentContext
            self.navigationController?.show(viewController3, sender: self)
            }
        }
    func showControllersForOrder() {
        if let viewController2 = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as? ProfileDetailsViewController,
               let viewController3 = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryInfoViewController") as? DeliveryInfoViewController { //change this to your identifiers
            viewController3.delegate = viewController2
            viewController2.modalPresentationStyle = .fullScreen
            //navigationController?.modalPresentationStyle = .fullScreen
            self.navigationController?.show(viewController2, sender: self)
            //show(viewController2, sender: self)
    }
    }
        //MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let vc = viewControllerToInsertBelow {
                    viewControllerToInsertBelow = nil
            let index = navigationController.viewControllers.firstIndex(of: viewController)!
            //indexOf(viewController)!
            navigationController.viewControllers.insert(vc, at: index)
            //insert(vc, atIndex: index)
        }
    }
}
