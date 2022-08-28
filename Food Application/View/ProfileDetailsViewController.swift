//
//  ProfileDetailsViewController.swift
//  Food Application
//
//  Created by Admin on 12.08.2022.
//

import UIKit

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
    var profileArray = [ClientInformation(image: UIImage(systemName: "person")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Кульбаев Санжар 79506626838"),
                        ClientInformation(image: UIImage(systemName: "message")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Комментарий курьеру"),
                        ClientInformation(image: UIImage(named: "дверь")!, rightImage: UIImage(systemName: "circle")!, text: "Оставить у двери"),
                        ClientInformation(image: UIImage(systemName: "phone")!, rightImage: UIImage(systemName: "circle")!, text: "Позвонить перед доставкой")]
    var timeArray = ["В течении часа", "12.00-13.00","13.00-14.00","14.00-15.00","15.00-16.00","16.00-17.00","17.00-18.00","18.00-19.00","19.00-20.00","20.00-21.00","21.00-22.00","22.00-23.00","23.00-00.00"]
    var cardArray = [Card(cardNumber: "1234", imageCard: UIImage(named: "visa"), cvc: nil, date1: nil, date2: nil),
                     Card(cardNumber: "1111", imageCard: UIImage(named: "Сбер"), cvc: nil, date1: nil, date2: nil),
                     Card(cardNumber: "1111", imageCard: UIImage(named: "visa"), cvc: nil, date1: nil, date2: nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")
        collectionView.register(UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        timeCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCollectionViewCell")
        cardsCollectionView.register(UINib(nibName: "CardsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardsCollectionViewCell")
        tableView.delegate = self
        collectionView.delegate = self
        timeCollectionView.delegate = self
        cardsCollectionView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        timeCollectionView.dataSource = self
        cardsCollectionView.dataSource = self
        
        Utilities.styleFilledButton(editButton)
        Utilities.styleFilledButton(payButton)
        self.view.layoutIfNeeded()
        heightTableView.constant = tableView.contentSize.height
        self.view.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        self.navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        labelSet()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    @IBAction func editButtonIsTapped(_ sender: Any) {
        openViewController()
    }
    func labelSet() {
        countProductsLabel.text = String(CartViewModel.shared.countPositions) + " товаров"
        countProductLabelRightDownCorner.text = String(CartViewModel.shared.countPositions) + " товаров"
        countProductLabelLeftDownCorner.text = "Товары (\(CartViewModel.shared.countPositions))"
        priceLabelUpper.text = "\(CartViewModel.shared.costForAll) ₽"
        priceLabel.text = "\(CartViewModel.shared.costForAll) ₽"
        addressLabel.text = (ProfileViewModel.shared.profile?.address)
    }
    func openViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DeliveryInfoViewController") as! DeliveryInfoViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.delegate = self
        self.navigationController?.show(nextViewController, sender: self)
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView {
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
            cell.setUp(card: cardArray[indexPath.item])
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
            return cardArray.count
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
}
extension ProfileDetailsViewController:DeliveryInfoViewControllerDelegate {
    func changeInfo(information: String, name: String, phoneNumber: String) {
        self.addressLabel.text = information
        ProfileViewModel.shared.profile?.address = information
        ProfileViewModel.shared.profile?.name = name
        ProfileViewModel.shared.profile?.phone =  phoneNumber
        ProfileViewModel.shared.setProfile()
    }
}


