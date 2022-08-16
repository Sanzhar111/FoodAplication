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
    var profileArray = [ClientInformation(image: UIImage(systemName: "person")!, rightImage: UIImage(systemName: "chevron.right")!  , text: "Кульбаев Санжар 79506626838"),
                        ClientInformation(image: UIImage(systemName: "message")!, rightImage: UIImage(systemName: "chevron.right")!, text: "Комментарий курьеру"),
                        ClientInformation(image: UIImage(named: "дверь")!, rightImage: UIImage(systemName: "circle")!  , text: "Оставить у двери"),
                        ClientInformation(image: UIImage(systemName: "phone")!, rightImage: UIImage(systemName: "circle")!  , text: "Позвонить перед доставкой")]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        Utilities.styleFilledButton(button)
        self.view.layoutIfNeeded()
        heightTableView.constant = tableView.contentSize.height
        self.view.layoutIfNeeded()

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
