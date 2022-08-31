//
//  CartViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 28/07/22.
//

import UIKit

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

//    let refreshControl = UIRefreshControl()
//    var cartProtocolDelegate = CartProductTableViewCell()
    
    @IBOutlet weak var placeOrder: UIButton!
    @IBOutlet weak var totalOrderView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartStatus: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    var productList:[ProductModel]?
    var cartOperationsAPI = CartOperationsAPI()
    var userId = UserDefaults.standard.integer(forKey: "Id")
    @IBOutlet weak var totalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCartTableViewCell()
    }
    
    func initilizer() {
//        cartProtocolDelegate.delegate = self
        cartStatus.isHidden = true
        searchButton.isHidden = true
        self.loadCartProducts()
        self.calculateCart()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        applyRoundBorders()
//        cartTableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
            cartTableView.reloadData()
//            refreshControl.endRefreshing()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerCartTableViewCell()
        self.loadCartProducts()
        self.calculateCart()
        self.initilizer()
//        cartTableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        registerCartTableViewCell()
//        cartTableView.delegate = self
//        cartTableView.dataSource = self
//        navigationController?.navigationBar.isHidden = true
//        applyRoundBorders()
//        loadCartProducts()
//    }
    
    func loadCartProducts() {
        cartOperationsAPI.getCartProducts(userId: UserDefaults.standard.integer(forKey: "Id")) { (products) in
            DispatchQueue.main.async {
                self.productList = products
                self.cartTableView.reloadData()
                self.calculateCart()
                print("\(#function) \(#file) Data Loaded")
            }
        }
    }
    
    func applyRoundBorders(){
        cartTableView.layer.masksToBounds = true
        cartTableView.layer.cornerRadius = 10
        placeOrder.layer.masksToBounds = true
        placeOrder.layer.cornerRadius = 15
    }
    
    func registerCartTableViewCell() {
        let nib = UINib(nibName: "CartProductTableViewCell", bundle: nil)
        cartTableView.register(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = productList ,products.count > 0{
            searchButton.isHidden = true
            cartStatus.isHidden = true
            return products.count
        }
        searchButton.isHidden = false
        cartStatus.isHidden = false
        cartStatus.text = "No Items in Cart Visit Store to Add"
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell") as? CartProductTableViewCell else {
            return UITableViewCell()
        }
        if let product = productList?[indexPath.row]{
            cell.product = product
            cell.loadProductData()
            cell.delegate = self
            cell.selectionStyle = .none
        } else {
            cell.product = nil
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/4)
    }
    
    
    @IBAction func placeOrder(_ sender: Any) {
        if let products = productList,products.count > 0 {
            performSegue(withIdentifier: "cartToCheckout", sender: nil)
        } else {
            let alertController = UIAlertController(title: "Cart Status", message: "Please Add Some Products to Checkout", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "cartToHome", sender: nil)
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var cart:[CartModel] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cartToCheckout" {
            if let product = productList {
                for item in product {
                    cart.append(CartModel(id: 0, userId: userId, productId: item.id, quantity: item.quantity, price: item.price, merchantId: item.merchant_id))
                }
            }
            guard let CheckoutView = segue.destination as? CheckoutViewController else {
                return
            }
            CheckoutView.productList = productList
        }
        
    }
    func calculateCart() {
        var total = 0
        if let productsList = productList {
            for product in productsList {
                total = total + (product.quantity! * product.price!)
            }
        }
        self.totalPrice.text = String(total)
    }
    
    
    @IBAction func searchForProducts(_ sender: Any) {
        performSegue(withIdentifier: "cartToHome", sender: nil)
    }
    
    
    // Reload Main View Controller Triggered By Child Vie
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CartViewController : CartProductTableViewCellDelegate {
    func reloadMainViewController() {
        DispatchQueue.main.async {
            self.viewDidLoad()
            self.loadCartProducts()
            self.cartTableView.reloadData()
            self.calculateCart()
            self.calculateCart()
        }
    }
}
