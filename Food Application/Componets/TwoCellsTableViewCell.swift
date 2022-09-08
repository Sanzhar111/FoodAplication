//
//  TwoCellsTableViewCell.swift
//  Food Application
//
//  Created by Admin on 20.07.2022.
//

import UIKit
protocol SelectedTableViewCellDelegate:class {
    func checkBoxToggle(sender: TwoCellsTableViewCell)
    func upValue(value:Int,sender:TwoCellsTableViewCell)
    func deleteRow(sender:TwoCellsTableViewCell)
}
class TwoCellsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:SelectedTableViewCellDelegate?
    var position:Position!
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
extension TwoCellsTableViewCell: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout,
                                 ChooseCollectionViewCellDelegate,
                                 ChoosenCollectionViewCellDelegate
{
    func checkBoxToggle(sender: Any) {
        if let selectedIndexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) {
            //data[selectedIndexPath.row].isChecked = !data[selectedIndexPath.row].isChecked
          //  CartViewModel.shared.cartPositions[selectedIndexPath.item].isSelected = !CartViewModel.shared.cartPositions[selectedIndexPath.item].isSelected
//            position.isSelected = !position.isSelected
           // collectionView.reloadItems(at: [selectedIndexPath])
            print("selected at - \(selectedIndexPath)")
            delegate?.checkBoxToggle(sender: self)
        }
    }
    
    func addValue(value: Int, sender: ChooseCollectionViewCell) {
        if let selectedIndexPath = collectionView.indexPath(for: sender) {
            print("the first value = \(value)")
            delegate?.upValue(value: value, sender: self)
        }
    }
    
    func deleteRow(sender: ChooseCollectionViewCell) {
        if let selectedIndexPath = collectionView.indexPath(for: sender) {
            delegate?.deleteRow(sender: self)
        }
    }
    
   /* func checkBoxToggle(sender: ProductListCollectionViewCell) {
        if let selectedIndexPath = collectionView.indexPath(for: sender) {
            //data[selectedIndexPath.row].isChecked = !data[selectedIndexPath.row].isChecked
          //  CartViewModel.shared.cartPositions[selectedIndexPath.item].isSelected = !CartViewModel.shared.cartPositions[selectedIndexPath.item].isSelected
//            position.isSelected = !position.isSelected
           // collectionView.reloadItems(at: [selectedIndexPath])
            print("selected at - \(selectedIndexPath)")
            delegate?.checkBoxToggle(sender: self)
        }
    }*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell!
        print(indexPath)
        print(indexPath.section)
        print(indexPath.item)
        switch indexPath.item {
        case 0 :
            let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as? ProductListCollectionViewCell
            cells?.setup(position: position)
            cells?.delegate = self
            cells?.button.isSelected = position.isSelected
            cell = cells
        default:
            let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCollectionViewCell", for: indexPath) as? ChooseCollectionViewCell
            cells?.setup(postions: position)
            //cells?.delegate = self
            cells?.delegate = self
            cell = cells
            
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath)
        switch indexPath.item {
        case 0:
            return CGSize(width: (self.bounds.width ) , height: 90)
        default:
            return CGSize(width: (self.bounds.width ) , height: 33)
        }
    }
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

