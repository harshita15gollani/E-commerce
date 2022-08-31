//
//  TabBarViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 29/07/22.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        self.selectedIndex = 1
        navigationController?.navigationBar.isHidden = true
    }
    

}
