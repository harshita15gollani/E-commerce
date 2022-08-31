//
//  CheckoutTableViewCell.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 31/07/22.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var priceForItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
