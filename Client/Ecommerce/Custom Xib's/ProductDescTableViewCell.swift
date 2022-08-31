//
//  ProductDescTableViewCell.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 29/07/22.
//

import UIKit

protocol ProductDescriptionDelegate : AnyObject {
    func addToCartAction()
    func placeOrderAction()
    func addressAlert()
}

class ProductDescTableViewCell: UITableViewCell {
    
    var product:ProductModel?
    var cartOperationsAPI = CartOperationsAPI()
    var delegate:ProductDescriptionDelegate?
    var userAPI = APICaller()
    var userProfile:UserProfileModel?
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var buyNowQtyStepper: UIStepper!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    var quantityLocal = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadProfile() {
        userAPI.getUserProfile(userId: UserDefaults.standard.integer(forKey: "Id")) { (profile) in
            DispatchQueue.main.async {
                self.userProfile = profile
            }
        }
    }
    
    func loadProduct() {
        loadProfile()
        buyNowQtyStepper.value = 1
        buyNowQtyStepper.minimumValue = 1
        if let productInfo = product{
            let url = productInfo.image?[0]
            productImage.load(urlString: url!)
            brand.text = productInfo.brand
            productTitle.text = productInfo.title
            stock.textColor = .red
            quantity.text = String(quantityLocal)
            if productInfo.stock! > 2 {
                addToCartButton.isEnabled = true
                addToCartButton.setAttributedTitle(NSAttributedString(string: "Add to Cart"), for: .normal)
                stock.textColor = .green
                stock.text = "Instock"
            } else {
                addToCartButton.isEnabled = false
                addToCartButton.setAttributedTitle(NSAttributedString(string: "Out of Stock"), for: .disabled)
                stock.textColor = .red
                stock.text = "Out Of Stock"
            }
            price.text = "$ \(String(productInfo.price!))"
            productDesc.text = productInfo.description
            if let productRating = productInfo.rating,productRating>0 {
                rating.text = "\(productRating)/5 🌟"
            }
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let cartDetails = CartModel(id: 0, userId: UserDefaults.standard.integer(forKey: "Id"), productId: product?.id, quantity: quantityLocal, price: product?.price, merchantId: product?.merchant_id)
        cartOperationsAPI.addToCart(cartModel: cartDetails) { (responseCartDetails) in
            if let _ = responseCartDetails {
                self.delegate?.addToCartAction()
                print("Product Added to Cart")
            } else {
                print("Failed to Add Product to Cart")
            }
        }
    }
    
    @IBAction func buyNow(_ sender: Any) {
        if let profile = userProfile, var productInfo = product {
            if profile.address != "", let address = profile.address{
            let cartInfo = CartModel(id: 0, userId: UserDefaults.standard.integer(forKey: "Id"), productId: productInfo.id, quantity: quantityLocal, price: productInfo.price, merchantId: productInfo.merchant_id)
            cartOperationsAPI.placeSingleOrder(cartObj: cartInfo) { (productUpdated) in
                DispatchQueue.main.async {
                    self.product = productUpdated
                    self.delegate?.placeOrderAction()
                }
            }
            }
            else {
                self.delegate?.addressAlert()
            }
        }
    }
    
    @IBAction func quantityUpdater(_ sender: Any) {
        if let productInfo = product {
            if quantityLocal < productInfo.stock! && quantityLocal > 0 {
                quantityLocal = Int(buyNowQtyStepper.value)
                quantity.text = String(quantityLocal)
            }
        }
    }
    
}
