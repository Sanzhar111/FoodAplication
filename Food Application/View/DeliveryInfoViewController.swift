//
//  DeliveryInfoViewController.swift
//  Food Application
//
//  Created by Admin on 22.08.2022.
//

import UIKit

class DeliveryInfoViewController: UIViewController {

    @IBOutlet weak var labelDelivery: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(saveButton)
        labelDelivery.sizeToFit()
    }
    
}
