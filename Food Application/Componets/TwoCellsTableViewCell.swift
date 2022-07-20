//
//  TwoCellsTableViewCell.swift
//  Food Application
//
//  Created by Admin on 20.07.2022.
//

import UIKit

class TwoCellsTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var position:Position!
    var nextCell = 2
    var nextCell2 = 2
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "ChooseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChooseCollectionViewCell")
        
        self.collectionView.register(UINib(nibName: "ProductListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductListCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TwoCellsTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /* let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        cell.setup(position: CartViewModel.shared.cartPositions[indexPath.item])
        */
        var cell : UICollectionViewCell!
        print(indexPath)
        print(indexPath.section)
        print(indexPath.item)
        switch nextCell {
        case nextCell where nextCell % 2 == 0:
            let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as? ProductListCollectionViewCell
            cells?.setup(position: position)
            cell = cells
            nextCell += 1
            print(nextCell)
        default:
            // case let k where k < 0:
            let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCollectionViewCell", for: indexPath) as? ChooseCollectionViewCell
//            cells.setup(position: CartViewModel.shared.cartPositions[indexPath.item])
            cell = cells
            nextCell -= 1
            print(nextCell)
        }
      //  CartViewModel.shared.positions
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // height += 90
        print(indexPath)
        switch nextCell2 {
        case nextCell2 where nextCell2 % 2 == 0:
            nextCell2 += 1
          //  print(nextCell2)
            return CGSize(width: (self.bounds.width ) , height: 90)
        default:
            // case let k where k < 0:
            nextCell2 -= 1
           // print(nextCell2)
            return CGSize(width: (self.bounds.width ) , height: 33)
        }
    }
/*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
  */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(section)
        return 0.5
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

