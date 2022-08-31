//
//  CheckoutViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 29/07/22.
//

import UIKit

class CheckoutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var checkoutTableView: UITableView!
    @IBOutlet weak var orderActivity: UIActivityIndicatorView!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    var productList:[ProductModel]?
    var cartAPI = CartOperationsAPI()
    var billInvoice:totalPrice?
    var billProducts:[CheckoutModel] = []
    var userProfile:UserProfileModel?
    var userAPI = APICaller()
    var total = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerTableViewCell()
        initilizeTable()
        loadDataFromAPI()
        loadProfile()
        orderActivity.isHidden = true
        orderActivity.stopAnimating()
    }
    
    func loadProfile() {
        userAPI.getUserProfile(userId: UserDefaults.standard.integer(forKey: "Id")) { (profile) in
            DispatchQueue.main.async {
                self.userProfile = profile
                self.deliveryAddress.text = profile.address!
                self.receiverName.text = profile.name!
            }
        }
    }
    
    func loadDataFromAPI() {
        cartAPI.getCartProducts(userId: UserDefaults.standard.integer(forKey: "Id")) { (products) in
            DispatchQueue.main.async {
                self.productList = products
                self.checkoutTableView.reloadData()
                self.billProducts.removeAll()
            }
        }
    }
    
    func initilizeTable() {
        checkoutTableView.delegate = self
        checkoutTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDataFromAPI()
        self.loadTotalPrice()
        self.loadTotalPrice()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func registerTableViewCell() {
        let nib = UINib(nibName: "CheckoutTableViewCell", bundle: nil)
        checkoutTableView.register(nib, forCellReuseIdentifier: "checkoutTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = productList {
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = checkoutTableView.dequeueReusableCell(withIdentifier: "checkoutTableViewCell") as? CheckoutTableViewCell else {
            return UITableViewCell()
        }
        if let productItem = productList?[indexPath.row]{
            let product = CheckoutModel(title: productItem.title!, quantity: productItem.quantity, price: productItem.price, totalPrice: productItem.price! * productItem.quantity! )
            cell.productTitle.text = productItem.title!
            cell.quantity.text = "X \(String(productItem.quantity!))"
            cell.priceForItem.text = "$ \(productItem.price!)"
            let total = productItem.price! * productItem.quantity!
            cell.totalPrice.text = "$ \(String(total))"
            print(product)
            self.billProducts.append(product)
            print(billProducts)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func loadTotalPrice() {
        total = 0
        if let products = productList {
            for item in products {
                total = total + item.price! * item.quantity!
            }
        }
        orderPrice.text = "$ \(String(total))"
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        orderActivity.isHidden = false
        orderActivity.startAnimating()
        self.billInvoice = totalPrice(userId: UserDefaults.standard.integer(forKey: "Id"), totalBill: total, products: billProducts)
        cartAPI.placeOrder(billInvoice: billInvoice!) { (status) in
            DispatchQueue.main.async {
                self.orderActivity.stopAnimating()
                self.orderActivity.isHidden = true
                let alertController = UIAlertController(title: "Order Status", message: "Order Placed Successfully Visit Orders page to check", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: "checkoutToHome", sender: nil)
                    print(status)
                    print("Ok button tapped");
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}



