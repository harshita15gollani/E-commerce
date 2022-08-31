//
//  CartProductTableViewCell.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 28/07/22.
//

import UIKit

protocol CartProductTableViewCellDelegate : AnyObject {
    func reloadMainViewController()
}

class CartProductTableViewCell: UITableViewCell {
    var delegate:CartProductTableViewCellDelegate?
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var quantityChanger: UIStepper!
    var product:ProductModel?
    var cartObj:CartModel?
    var cartOpAPI = CartOperationsAPI()
    var productQuantity = 0
    var productId = 0
    let cartView = CartViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadProductData(){
        print(UserDefaults.standard.integer(forKey: "Id"))
        quantityChanger.minimumValue = 0
        quantityChanger.value = Double(productQuantity)
        if let productInfo = product{
            productId = productInfo.id!
            productImage.load(urlString: productInfo.image?[0] ?? "")
            productTitle.text = productInfo.title
            price.text = "$ \(String(productInfo.price ?? 0))"
            productQuantity = productInfo.quantity!
            quantity.text = String(Int(quantityChanger.value))
        }
    }
    
    @IBAction func updateQuantity(_ sender: Any) {
        if quantityChanger.value == 0 {
            self.deleteProduct()
        } else {
        if let productinfo = product ,Int(quantityChanger.value) > productinfo.stock! {
            print("Out of Stock")
            quantityChanger.value = Double(productinfo.stock!)
            self.loadProductData()
            self.loadProductData()
                } else {
                    let cart = CartModel(id: 0, userId: UserDefaults.standard.integer(forKey: "Id"), productId: productId, quantity: Int(quantityChanger.value), price: 0, merchantId: 0)
                    cartOpAPI.updateCartQuantity(cartObj: cart) { (productUpdated) in
                        DispatchQueue.main.async {
                            self.product = productUpdated
                            self.delegate?.reloadMainViewController()
                            self.delegate?.reloadMainViewController()
                            print(self.product)
                        }
                    }
                }
    }
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        self.deleteProduct()
    }
    
    func deleteProduct() {
        let cart = CartModel(id: 0, userId: UserDefaults.standard.integer(forKey: "Id"), productId: productId, quantity: productQuantity, price: 0, merchantId: 0)
        cartOpAPI.deleteProductFromCart(cartObj: cart) { (status) in
            DispatchQueue.main.async {
                print(status)
                self.delegate?.reloadMainViewController()
                self.delegate?.reloadMainViewController()
            }
        }
    }
    
}
