//
//  CathalogViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//

import UIKit
import SkeletonView
final class CathalogViewController: UIViewController {
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var height1: NSLayoutConstraint!
    @IBOutlet weak var height2: NSLayoutConstraint!
    @IBOutlet weak var height3: NSLayoutConstraint!
   // @IBOutlet weak var viewHeight: NSLayoutConstraint!
    private var viewHeightVar = 0
    //private var products = Menu()
    private var height = 0
    private var viewModel = CathalogViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.scroller.isUserInteractionEnabled = true
        self.tableView1.register(UINib(nibName: "ListOfProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOfProductsTableViewCell")
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView1.isUserInteractionEnabled = true
       
        self.tableView2.register(UINib(nibName: "ListOfProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOfProductsTableViewCell")
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        self.tableView2.isUserInteractionEnabled = true
        tableView2.allowsSelection = true
        
        
        self.tableView3.register(UINib(nibName: "ListOfProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOfProductsTableViewCell")
        self.tableView3.delegate = self
        self.tableView3.dataSource = self
        self.tableView3.isUserInteractionEnabled = true
        viewModel.getPopularOrders { res in
            switch res {
            case .success(let product):
                self.viewModel.products.popular = product
                self.viewModel.products.healthy = product
                self.viewModel.products.tasty = product
                for i in 0..<self.viewModel.products.popular.count {
                    self.viewModel.getProductImage(index: i) { result in
                        switch result {
                        case .success(let image):
                            self.viewModel.products.popular[i].image = image
                            self.viewModel.products.tasty[i].image = image
                            self.viewModel.products.healthy[i].image = image
                            if i == self.viewModel.products.popular.count - 1  {
                                DispatchQueue.main.async {
                                    print(self.viewModel.products.popular.count)
                                    self.tableView1.reloadData()
                                    self.tableView2.reloadData()
                                    self.tableView3.reloadData()
                                    self.heightSetup()
                                }
                        }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
       // navigationController?.navigationBar.backgroundColor = .brown
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView1.reloadData()
        self.tableView2.reloadData()
        self.tableView3.reloadData()
            // self.heightSetup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension CathalogViewController:UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return viewModel.products.popular.count
        } else if tableView == tableView2 {
            return viewModel.products.tasty.count
        } else {
            return viewModel.products.healthy.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfProductsTableViewCell", for: indexPath) as! ListOfProductsTableViewCell
            cell.selectionStyle = .none
            let product = viewModel.products.popular[indexPath.item]
            cell.setUp(product: product)
            return cell
        } else if tableView == tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfProductsTableViewCell", for: indexPath) as! ListOfProductsTableViewCell
            let product = viewModel.products.tasty[indexPath.item]
            cell.selectionStyle = .none
            cell.setUp(product: product)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfProductsTableViewCell", for: indexPath) as! ListOfProductsTableViewCell
            let product = viewModel.products.healthy[indexPath.item]
            cell.selectionStyle = .none
            cell.setUp(product: product)
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewModel = DetailViewModel(product: viewModel.products.popular[indexPath.item])
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tableView == tableView2 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: viewModel.products.tasty[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: viewModel.products.healthy[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func heightSetup() {
        self.view.layoutIfNeeded()
        self.height1.constant = CGFloat(self.viewModel.products.popular.count * 100)
        self.height2.constant = CGFloat(self.viewModel.products.tasty.count * 100)
        self.height3.constant = CGFloat(self.viewModel.products.healthy.count * 100)
       self.view.layoutIfNeeded()
    }
    
   /* func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell", for: indexPath) as! ListOfTheProductsCell
            let product = viewModel.products.popular[indexPath.item]
            cell.setUp(product:product )
            return cell
        } else if collectionView == collectionView2 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell", for: indexPath) as! ListOfTheProductsCell
            let product = viewModel.products.tasty[indexPath.item]
            cell.setUp(product:product )
            return cell
        } else {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell", for: indexPath) as! ListOfTheProductsCell
            let product = viewModel.products.healthy[indexPath.item]
            cell.setUp(product:product )
            return cell
        }
    }*/
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return viewModel.products.popular.count
        } else if collectionView == collectionView2 {
            return viewModel.products.tasty.count
        } else {
            return viewModel.products.healthy.count
        }
    }*/
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // height += 60
        return CGSize(width: (self.view.bounds.width  - 5) , height: 120)
    }*/
    
   /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView1 {
            print("selecetd 1")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewModel = DetailViewModel(product: viewModel.products.popular[indexPath.item])
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == collectionView2 {
            print("selecetd 2")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: viewModel.products.tasty[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("selecetd 3")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: viewModel.products.healthy[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }*/
    
}
