//
//  ExampleViewController.swift
//  Food Application
//
//  Created by Admin on 09.06.2022.
//

//
//  CathalogViewController.swift
//  Food Application
//
//  Created by Admin on 18.05.2022.
//
import UIKit

class ExampleViewController: UIViewController {
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var height1: NSLayoutConstraint!
    @IBOutlet weak var height2: NSLayoutConstraint!
    @IBOutlet weak var height3: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    var products = Menu()
    var height = 0
    var viewHeightVar = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView1.register(UINib(nibName: "ListOfTheProductsCell", bundle: nil), forCellWithReuseIdentifier: "ListOfTheProductsCell1")
        self.collectionView1.delegate = self
        self.collectionView1.dataSource = self
        self.collectionView1.isUserInteractionEnabled = true
       
        self.collectionView2.register(UINib(nibName: "ListOfTheProductsCell", bundle: nil), forCellWithReuseIdentifier: "ListOfTheProductsCell2")
        self.collectionView2.delegate = self
        self.collectionView2.dataSource = self
        self.collectionView2.isUserInteractionEnabled = true
        collectionView2.allowsSelection = true
        
        self.collectionView3.register(UINib(nibName: "ListOfTheProductsCell", bundle: nil), forCellWithReuseIdentifier: "ListOfTheProductsCell3")
        self.collectionView3.delegate = self
        self.collectionView3.dataSource = self
        self.collectionView3.isUserInteractionEnabled = true
        self.scroller.isUserInteractionEnabled = true
        self.view.layoutIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        scroller.isScrollEnabled = true
        heightSetup()
        scroller.contentSize = CGSize(width: scroller.contentSize.width, height:  CGFloat(self.collectionView3.frame.maxY*1.5))
    }
}
extension ExampleViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell1", for: indexPath) as! ListOfTheProductsCell
            let product = products.popular[indexPath.item]
            cell.setUp(product:product )
            return cell
        } else if collectionView == collectionView2 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell2", for: indexPath) as! ListOfTheProductsCell
            let product = products.tasty[indexPath.item]
            cell.setUp(product:product )
            return cell
        } else {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfTheProductsCell3", for: indexPath) as! ListOfTheProductsCell
            let product = products.healthy[indexPath.item]
            cell.setUp(product:product )
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return products.popular.count
        } else if collectionView == collectionView2 {
            return products.tasty.count
        } else {
            return products.healthy.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        height += 90
        return CGSize(width: (self.view.bounds.width  - 5)/2 , height: 90)// give the size for cells
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewModel = DetailViewModel(product: products.popular[indexPath.item])
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == collectionView2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: products.tasty[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FullProductViewController") as! DetailViewController
            let viewModel = DetailViewModel(product: products.healthy[indexPath.item])
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    func heightSetup() {
        self.height1.constant = self.collectionView1.contentSize.height
        self.height2.constant = self.collectionView2.contentSize.height
        self.height3.constant = self.collectionView3.contentSize.height
        viewHeightVar = Int(height1.constant + height2.constant + height3.constant)
        self.viewHeight.constant = CGFloat(viewHeightVar)
    }
}
