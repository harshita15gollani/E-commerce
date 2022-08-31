//
//  ProductTableViewCell.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: UILabel!
    var product:ProductModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
