//
//  ProfileDetailsViewController.swift
//  Food Application
//
//  Created by Admin on 12.08.2022.
//

import UIKit
protocol ProfileDetailsDelegate:Any {
    func table(tableView:UITableView)
}
class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var countProductsLabel: UILabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var countProductLabelLeftDownCorner: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelUpper: UILabel!
    @IBOutlet weak var countProductLabelRightDownCorner: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var indexOfACard:Int = -1
    var addressVariable = ""
    var nameVariable = ""
    var phoneVariable = ""
    var profileArray = [ClientInformation(image: UIImage(systemName: "person")!, rightImage: UIImage(systemName: "chevron.right")!, text: "\(ProfileViewModel.shared.profile?.name ?? "") \(ProfileViewModel.shared.profile?.phone ?? "") ",isChosen: false),
                        ClientInformation(image: UIImage(systemName: "message")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Комментарий курьеру",isChosen: false),
                        ClientInformation(image: UIImage(named: "дверь")!, rightImage: UIImage(systemName: "circle")!, text: "Оставить у двери",isChosen: false),
                        ClientInformation(image: UIImage(systemName: "phone")!, rightImage: UIImage(systemName: "circle")!, text: "Позвонить перед доставкой",isChosen: false)]
    var selectedCell:IndexPath = IndexPath.init(row: 0, section: 0)
    var timeArray = ["В течении часа", "12.00-13.00","13.00-14.00","14.00-15.00","15.00-16.00","16.00-17.00","17.00-18.00","18.00-19.00","19.00-20.00","20.00-21.00","21.00-22.00","22.00-23.00","23.00-00.00"]
    var cardArray = Card(userId: "", imageCard: nil, imageView: UIImage(named: "addCard"), cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false)
    var order = Order(userId: AuthService.shared.auth.currentUser!.uid, date: Date(), status: OrderStatus.new.rawValue, paidCard: Card(userId: "", imageCard: nil, imageView: nil, cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false))
    var viewModel = ProfileDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpDelegatesAndDataSources()
        Utilities.styleFilledButton(editButton)
        Utilities.styleFilledButton(payButton)
        self.view.layoutIfNeeded()
        heightTableView.constant = tableView.contentSize.height
        self.view.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        self.navigationItem.hidesBackButton = true
        //viewModel.cardArray.append(Card(userId: "", imageCard: nil, imageView: UIImage(named: "addCard"), cardNumber: "", cvc: "", date1: "", date2: "", isSelected: false))
        print(viewModel.cardArray.count)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        labelSet()
    }
    func setUpDelegatesAndDataSources() {
        tableView.delegate = self
        collectionView.delegate = self
        timeCollectionView.delegate = self
        cardsCollectionView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        timeCollectionView.dataSource = self
        cardsCollectionView.dataSource = self
    }
    func registerCells() {
        tableView.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")
        collectionView.register(UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        timeCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCollectionViewCell")
        cardsCollectionView.register(UINib(nibName: "CardsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardsCollectionViewCell")
    }
    
    func labelSet() {
        countProductsLabel.text = String(CartViewModel.shared.countPositions) + " товаров"
        countProductLabelRightDownCorner.text = String(CartViewModel.shared.countPositions) + " товаров"
        countProductLabelLeftDownCorner.text = "Товары (\(CartViewModel.shared.countPositions))"
        priceLabelUpper.text = "\(CartViewModel.shared.costForAll) ₽"
        priceLabel.text = "\(CartViewModel.shared.costForAll) ₽"
        
        if addressVariable != "" {
            addressLabel.text = addressVariable
        } else {
            addressLabel.text = (ProfileViewModel.shared.profile?.address)
        }
        tableView.reloadData()
    }
    func openViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DeliveryInfoViewController") as! DeliveryInfoViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    func showAlertController(textTitle:String,textOfAction1:String,textOfAction2:String,completion:@escaping ()->()) {
        let alertContoller = UIAlertController(title:textTitle, message: nil , preferredStyle: .alert)
        let alerAction = UIAlertAction(title: textOfAction1, style: .default) { [weak self] action in
           // self?.viewModel.deleteAllProducts()
            completion()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.labelSet()
            }
        }
        let alerAction2 = UIAlertAction(title: textOfAction2, style: .default)
        alertContoller.addAction(alerAction)
        alertContoller.addAction(alerAction2)
        self.present(alertContoller, animated: true)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
       /* for i in 0 ..< cardArray.count {
            cardArray[i].isSelected = false
        }*/
    selectedCell = IndexPath.init(row: 0, section: 0)
    }
    @IBAction func editButtonIsTapped(_ sender: Any) {
        openViewController()
    }
    @IBAction func payButtonIsTapped(_ sender: UIButton) {
        print("indes",indexOfACard)
        if indexOfACard == 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PayCardViewController") as! PayCardViewController
            nextViewController.modalPresentationStyle = .fullScreen
            nextViewController.priceVariable = String(CartViewModel.shared.costForAll) + " ₽"
            nextViewController.textForAButton = "Оплатить \(CartViewModel.shared.costForAll) ₽"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            
            self.order.positions = CartViewModel.shared.cartPositions
            CartViewModel.shared.cartPositions.removeAll()
            collectionView.reloadData()
            labelSet()
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
    @IBAction func deleteAllCartPositionsButtonIsTapped(_ sender: Any) {
        showAlertController(textTitle: "Очистить корзину", textOfAction1: "Да", textOfAction2: "Отмена", completion: { [weak self] () in
            self?.viewModel.deleteAllProducts()
        })
    }
    
}
extension ProfileDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as! ProfileDetailTableViewCell
        cell.selectionStyle = .none
        cell.setup(profile:profileArray[indexPath.row] )
        print("indexPath.row = ",indexPath.row)
        cell.theCellTableView = self.tableView
        if indexPath.row > 1 {
           print("Yes")//
        cell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            switch indexPath.row {
            case 0: openViewController()
            case 1: openViewController()
            default:
                print("not that")
            }
        }
        print("i amds \(indexPath.row)")
    }
}
extension ProfileDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! OrderDetailsCollectionViewCell
            cell.delegate = self
            cell.setup(product: CartViewModel.shared.cartPositions[indexPath.item])
            return cell
        } else if collectionView == self.timeCollectionView  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
            cell.timeLabel.text = timeArray[indexPath.item]
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 6
            cell.layer.borderWidth = 1
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsCollectionViewCell", for: indexPath) as! CardsCollectionViewCell
            print(viewModel.cardArray.count)
            cell.setUp(card: viewModel.cardArray[indexPath.item])
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 6
            cell.layer.borderWidth = 1
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            print(CartViewModel.shared.cartPositions.count)
            return CartViewModel.shared.cartPositions.count
        } else if collectionView == self.timeCollectionView {
            return timeArray.count
        } else {
            print(viewModel.cardArray.count)
            return  viewModel.cardArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: self.view.bounds.width / 3, height: 128)
        } else if collectionView == self.timeCollectionView {
            return CGSize(width: self.view.bounds.width / 3, height: 60)
        } else {
            return CGSize(width: self.view.bounds.width / 3, height: 64)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardsCollectionView {
         
                var selectedcell = collectionView.cellForItem(at: indexPath)
                //let notSelectedcell = collectionView.cellForItem(at: selectedCell)
            print("indexPath = \(indexPath)")
            print("NITindexPath = \(selectedCell)\n")
              
                    if selectedCell.row != indexPath.row {
                        //cardArray[indexPath.row].isSelected = true
                        //cardArray[selectedCell.row].isSelected = false
                        viewModel.cardArray[indexPath.row].isSelected = true
                        viewModel.cardArray[selectedCell.row].isSelected = false
                        /*  notSelectedcell?.layer.cornerRadius = 6
                        notSelectedcell!.layer.borderWidth = 1.0
                        notSelectedcell!.layer.borderColor = UIColor.white.cgColor
                        */
                        print("indexPath = \(indexPath)")
                        print("NITindexPath = \(selectedCell)\n")

                        selectedcell = collectionView.cellForItem(at: selectedCell)
                        selectedcell?.layer.cornerRadius = 6
                        selectedcell!.layer.borderWidth = 1.0
                        selectedcell!.layer.borderColor = UIColor.lightGray.cgColor
                        //collectionView.reloadItems(at: [selectedCell])

                        print("indexPath = \(indexPath)")
                        print("NITindexPath = \(selectedCell)\n")

                        selectedcell = collectionView.cellForItem(at: indexPath)
                        selectedcell?.layer.cornerRadius = 6
                        selectedcell!.layer.borderWidth = 1.0
                        selectedcell!.layer.borderColor = UIColor.blue.cgColor
                        indexOfACard = indexPath.row
                        print("The ",indexOfACard)
                        /*if indexPath.row == 0 {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PayCardViewController") as! PayCardViewController
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                        }*/
                        selectedCell = indexPath
                    } else if (selectedCell.row == indexPath.row) && (viewModel.cardArray[indexPath.row].isSelected == false) {
                        print("hh]n")
                        indexOfACard = indexPath.row
                        viewModel.cardArray[indexPath.row].isSelected = true
                        selectedcell?.layer.cornerRadius = 6
                        selectedcell!.layer.borderWidth = 1.0
                        selectedcell!.layer.borderColor = UIColor.blue.cgColor
                        selectedCell = indexPath
                    }
        }
    }
    /*func upValue(value: Int, sender: TwoCellsTableViewCell) {
        print("the major value = \(value)")
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            print("is seleceted(=)==\(selectedIndexPath)")
            CartViewModel.shared.cartPositions[selectedIndexPath.row].count = value
            priceForAllLabel.text = "\(CartViewModel.shared.costForAll)₽"
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
        }
    }*/
}
extension ProfileDetailsViewController:DeliveryInfoViewControllerDelegate {
    func changeInfo(information: String, name: String, phoneNumber: String) {
        self.addressVariable = information
        profileArray[0].text = name + " " + phoneNumber
        ProfileViewModel.shared.profile?.address = information
        ProfileViewModel.shared.profile?.name = name
        ProfileViewModel.shared.profile?.phone =  phoneNumber
        labelSet()
        ProfileViewModel.shared.setProfile()
    }
}
extension ProfileDetailsViewController:InfoForDeliveryDelegate {
    func updateInfo(name: String, address: String, country: String, city: String, street: String, numberHouse: String, phone: String) {
        addressVariable = address
        profileArray[0].text = name + " " + phone
        ProfileViewModel.shared.profile?.name = name
        ProfileViewModel.shared.profile?.country = country
        ProfileViewModel.shared.profile?.city = city
        ProfileViewModel.shared.profile?.street = street
        ProfileViewModel.shared.profile?.numberHouse = numberHouse
        ProfileViewModel.shared.profile?.phone = phone
        ProfileViewModel.shared.profile?.address = address
        //labelSet()
        ProfileViewModel.shared.setProfile()
    }
    
    
}

extension ProfileDetailsViewController:ChoosenCollectionViewCellDelegate {
    func checkBoxToggle(sender: Any) {
        if let selectedIndexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            print("is seleceted(=)==\(selectedIndexPath)")
            print(profileArray[selectedIndexPath.row].isChosen)
            profileArray[selectedIndexPath.row].isChosen = !profileArray[selectedIndexPath.row].isChosen
            if selectedIndexPath.row == 2 {
                order.leaveNextToTheDoor = profileArray[selectedIndexPath.row].isChosen
            } else {
                order.callBeforeDelivey = profileArray[selectedIndexPath.row].isChosen
            }
            print(profileArray[selectedIndexPath.row].isChosen)
            //            data[selectedIndexPath.row].isChecked = !data[selectedIndexPath.row].isChecked
            //tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
    }
}
extension ProfileDetailsViewController: OrderDetailsCollectionViewCellDelegate {
    func deletePosition(sender: Any) {
        if let selectedCell =  collectionView.indexPath(for: (sender as? UICollectionViewCell)!) {
            showAlertController(textTitle: "Удалить товар", textOfAction1: "Да", textOfAction2: "Отмена") {
                print("before",CartViewModel.shared.cartPositions.count)
                CartViewModel.shared.cartPositions.remove(at: selectedCell.row)
                print("After",CartViewModel.shared.cartPositions.count)
            }
        }
    }
}
