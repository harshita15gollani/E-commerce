//
//  CatelogViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import UIKit

class CatelogViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionViewCell()
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
    }
    
    func registerCollectionViewCell(){
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        topRatedCollectionView.register(nib, forCellWithReuseIdentifier: "productCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.productImage.image = UIImage(named: "/Users/jogireddy/Downloads/welcome.png")
        cell.productName.text = "Product Name"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-40)/4,height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

}
