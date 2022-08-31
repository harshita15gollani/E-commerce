//
//  ProductCatelogViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import UIKit

class ProductCatelogViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITabBarDelegate {
    
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var newArrivalsCollectionView: UICollectionView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var topBrandLabel: UILabel!
    
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var productList: [ProductModel?]?
    var searchResult: [ProductModel]?
    var apiCaller = APICaller()
    let tabViewController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerTableViewCell()
        registerCollectionViewCell()
        initilizeDelegates()
        loadRecommandations()
        searchLabel.isHidden = true
        navigationController?.navigationBar.isHidden = true
        productTableView.refreshControl = refreshControl
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        initilizeDelegates()
    //        loadRecommandations()
    //        navigationController?.navigationBar.isHidden = true
    //        recoLabel.isHidden = false
    //        topBrandLabel.isHidden = false
    //    }
    
    
    func initilizeDelegates() {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.isHidden = true
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        newArrivalsCollectionView.delegate = self
        newArrivalsCollectionView.dataSource = self
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        if let search = searchBar.text{
            apiCaller.getSearchResult(query: search) { (searchProd) in
            DispatchQueue.main.async {
                if searchProd?.count == 0 {
                    self.searchLabel.isHidden = false
                    self.searchLabel.text = "No Result Found"
                }
                self.searchResult = searchProd
                self.loadSearch()
                self.refreshControl.endRefreshing()
            }
            }
        }
            productTableView.reloadData()
            refreshControl.endRefreshing()
        }
    
    func loadRecommandations() {
        apiCaller.getListOfProducts { (products) in
            DispatchQueue.main.async {
                self.productList = products
                print(self.productList!)
                self.secondCollectionView.reloadData()
                self.newArrivalsCollectionView.reloadData()
            }
        }
    }
    func registerTableViewCell(){
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        productTableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
    }
    
    func registerCollectionViewCell(){
        let nib = UINib(nibName: "ProductTableCollectionViewCell", bundle: nil)
        firstCollectionView.register(nib, forCellWithReuseIdentifier: "productCollectionView")
        secondCollectionView.register(nib, forCellWithReuseIdentifier: "productCollectionView")
        newArrivalsCollectionView.register(nib, forCellWithReuseIdentifier: "productCollectionView")
    }
    
    //MARK:Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let search = searchResult {
            return search.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as? ProductTableViewCell else {
            return UITableViewCell()
        }
        if let product = searchResult?[indexPath.row] {
            cell.productImage.load(urlString: (product.image?[0])!)
            cell.productTitle.text = product.title!
            cell.price.text = "$ \(String(product.price!))"
            cell.brand.text = product.brand!
            cell.rating.text = String(product.rating!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productAt = searchResult?[indexPath.row]
        performSegue(withIdentifier: "homeToProductDesc", sender: nil)
    }
    
    //MARK: SearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult?.removeAll()
        searchLabel.isHidden = true
        categories.isHidden = false
        productTableView.reloadData()
        productTableView.isHidden = true
        topBrandLabel.isHidden = false
        loadRecommandations()
        firstCollectionView.isHidden = false
        secondCollectionView.isHidden = false
        firstCollectionView.reloadData()
        secondCollectionView.reloadData()
    }
    
    
    
    
    //MARK: Collection View Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.firstCollectionView {
            return 1
        } else if collectionView == self.secondCollectionView{
            return 1
        } else if collectionView == newArrivalsCollectionView
        {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.firstCollectionView {
            return 5
        } else if collectionView == self.secondCollectionView {
            return 5
        } else if collectionView == newArrivalsCollectionView{
            if let products = productList {
                return products.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionView", for: indexPath) as? ProductTableCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.productImage.image = nil
        if collectionView == secondCollectionView {
            cell.productImage.image = UIImage(named: cat[indexPath.row])
            return cell
        } else if(collectionView == firstCollectionView){
                cell.productImage.image = UIImage(named: brandImages[indexPath.row])
                return cell
        } else if collectionView == newArrivalsCollectionView {
            if let products = productList, let product = products[indexPath.row]{
                if let image = product.image {
                cell.productImage.load(urlString: image[0] )
                }
            }
            return cell
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == firstCollectionView {
        return 10
        } else if collectionView == secondCollectionView {
            return 5
        } else if collectionView == newArrivalsCollectionView {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == firstCollectionView {
        return 10
        }else  if collectionView == secondCollectionView {
            return 0
        } else if collectionView ==  newArrivalsCollectionView{
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.firstCollectionView {
            return CGSize(width: collectionView.bounds.width/6, height: collectionView.bounds.height*10)
        } else if collectionView ==  secondCollectionView {
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height/2)
        } else if collectionView == newArrivalsCollectionView {
            return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    var productAt:ProductModel?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.firstCollectionView {
            searchBar.text = brandNames[indexPath.row]
            apiCaller.getProductsByBrand(brand: brandNames[indexPath.row]) { (searchProd) in
                DispatchQueue.main.async {
                    if searchProd?.count == 0 {
                        self.searchLabel.isHidden = false
                        self.searchLabel.text = "No Result Found"
                    }
                    self.searchResult = searchProd
                    self.loadSearch()
                }
            }
        } else if collectionView == self.secondCollectionView {
            searchBar.text = catNames[indexPath.row]
            apiCaller.getSearchResult(query: catNames[indexPath.row]) { (searchProd) in
                DispatchQueue.main.async {
                    if searchProd?.count == 0 {
                        self.searchLabel.isHidden = false
                        self.searchLabel.text = "No Result Found"
                    }
                    self.searchResult = searchProd
                    self.loadSearch()
                }
            }
        } else if collectionView == newArrivalsCollectionView {
            if let products = productList{
                productAt = products[indexPath.row]
                performSegue(withIdentifier: "homeToProductDesc", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToProductDesc" {
            guard let productView = segue.destination as? ProductDescriptionViewController else {
                return
            }
            productView.product = productAt
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if let search = searchBar.text {
            apiCaller.getSearchResult(query: search) { (searchProd) in
                DispatchQueue.main.async {
                    if searchProd?.count == 0 {
                        self.searchLabel.isHidden = false
                        self.searchLabel.text = "No Result Found"
                    }
                    self.searchResult = searchProd
                    self.loadSearch()
                }
            }
        }
    }
    
    func loadSearch() {
        categories.isHidden = true
        topBrandLabel.isHidden = true
        firstCollectionView.isHidden = true
        secondCollectionView.isHidden = true
        productTableView.isHidden = false
        productTableView.reloadData()
        print(searchResult)
    }
}
