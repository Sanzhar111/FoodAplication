//
//  OrderTableViewCell.swift
//  Food Application
//
//  Created by Admin on 15.06.2022.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setup(order:Order) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm" // или какой формат нужен
        let dateString = formatter.string(from: order.date as Date)
        self.dateLabel.text = dateString
        self.priceLabel.text = String(order.cost)
        self.orderLabel.text = String(order.status)
        //nameLabel.text = order.
    }
    
    
    
}
