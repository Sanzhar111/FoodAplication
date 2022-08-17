//
//  ProfileDetailsViewController.swift
//  Food Application
//
//  Created by Admin on 12.08.2022.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var countProductsLabel: UILabel!
    var profileArray = [ClientInformation(image: UIImage(systemName: "person")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Кульбаев Санжар 79506626838"),
                        ClientInformation(image: UIImage(systemName: "message")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Комментарий курьеру"),
                        ClientInformation(image: UIImage(named: "дверь")!, rightImage: UIImage(systemName: "circle")!, text: "Оставить у двери"),
                        ClientInformation(image: UIImage(systemName: "phone")!, rightImage: UIImage(systemName: "circle")!, text: "Позвонить перед доставкой")]
    var timeArray = ["В течении часа", "12.00-13.00","13.00-14.00","14.00-15.00","15.00-16.00","16.00-17.00","17.00-18.00","18.00-19.00","19.00-20.00","20.00-21.00","21.00-22.00","22.00-23.00","23.00-00.00"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.register(UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        timeCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCollectionViewCell")
        Utilities.styleFilledButton(button)
        self.view.layoutIfNeeded()
        heightTableView.constant = tableView.contentSize.height
        self.view.layoutIfNeeded()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        countProductsLabel.text = String(CartViewModel.shared.countPositions) + " товаров"
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
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
            print("i amds \(indexPath.row)")
    }
}
extension ProfileDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! OrderDetailsCollectionViewCell
            cell.setup(product: CartViewModel.shared.cartPositions[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
            cell.timeLabel.text = timeArray[indexPath.item]
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
        } else {
            return timeArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: self.view.bounds.width / 3, height: 128)
        } else {
            return CGSize(width: self.view.bounds.width / 3, height: 60)
        }
    }
}
