//
//  ProductDescriptionViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 29/07/22.
//

import UIKit

class ProductDescriptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ProductDescriptionDelegate {
    
    func addressAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Profile Error", message: "Please Update your Address in Profile Section", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func placeOrderAction() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Order Status", message: "Order Placed Success Check Order History", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addToCartAction() {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Cart Status", message: "Product Added to Cart, Please Visit Cart to Place Order", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction!) in
                print("Ok button tapped");
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
    }
    
    
    

    @IBOutlet weak var productTableView: UITableView!
    
    var product:ProductModel?
    var productDescTableCell = ProductDescTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerProductTableViewCell()
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    func registerProductTableViewCell() {
        let nib = UINib(nibName: "ProductDescTableViewCell", bundle: nil)
        productTableView.register(nib, forCellReuseIdentifier: "productDescTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productDescTableViewCell") as? ProductDescTableViewCell else {
            return UITableViewCell()
        }
        cell.product = product
        cell.loadProduct()
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(tableView.bounds.height)
//    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}


