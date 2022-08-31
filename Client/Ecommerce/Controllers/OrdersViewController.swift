//
//  OrdersViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 28/07/22.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var orderTable: UITableView!
    
    var productList:[ProductModel]?
    var cartAPI = CartOperationsAPI()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initilizerBlock()
        registerTable()
        loadDataFromAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromAPI()
        registerTable()
        initilizerBlock()
    }
    
    func initilizerBlock() {
        orderTable.delegate = self
        orderTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = productList {
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = orderTable.dequeueReusableCell(withIdentifier: "checkoutTableViewCell") as? CheckoutTableViewCell else {
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
        }
        return cell
    }
    
    
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerTable() {
        let nib = UINib(nibName: "CheckoutTableViewCell", bundle: nil)
        orderTable.register(nib, forCellReuseIdentifier: "checkoutTableViewCell")
    }
    
    func loadDataFromAPI() {
        cartAPI.getOrderDetails(userId: UserDefaults.standard.integer(forKey: "Id")) { (products) in
            DispatchQueue.main.async {
                self.productList = products
                print(products)
                self.orderTable.reloadData()
            }
        }
    }
    
}
