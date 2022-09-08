//
//  ProfileDetailTableViewCell.swift
//  Food Application
//
//  Created by Admin on 16.08.2022.
//

import UIKit

class ProfileDetailTableViewCell: UITableViewCell {

    @IBOutlet var myimageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var rightImage: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    weak var delegate:ChoosenCollectionViewCellDelegate?
    var theCellTableView:UITableView?
    var isSelectedButton = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(profile:ClientInformation) {
        self.myimageView.image = profile.image
        self.rightImage.setImage(profile.rightImage, for: .normal)
        self.myimageView.tintColor = .black
        self.label.text = profile.text
    }
    @IBAction func chosenButtonIsTapped(_ sender: Any) {

        let theSelectedCell = theCellCanBeChosen()
        if  theSelectedCell  {
            self.delegate?.checkBoxToggle(sender: self)
            setUpButton()
        }
        
    }
    func theCellCanBeChosen() -> Bool {
        if let selectedIndexPath = theCellTableView?.indexPath(for: self) {
            print("the path is ==\(selectedIndexPath)")
            if selectedIndexPath.row < 2 {
                return false
            } else {
                return true
            }
        }
             return false
    }
    func setUpButton() {
        if isSelectedButton {
            let origImage = UIImage(systemName: "circle")!
            let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(tintedImage, for: .normal)
            rightButton.tintColor = .black
            isSelectedButton = !isSelectedButton
        } else {
            let origImage = UIImage(systemName: "checkmark.circle")!
            let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(tintedImage, for: .normal)
            rightButton.tintColor = .black
            isSelectedButton = !isSelectedButton
        }
    }

}
