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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
}
