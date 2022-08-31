//
//  MenuViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 28/07/22.
//

import UIKit

enum SIdentifier:String {
    case profile = "menuToUserProfile"
    case help = "menuToHelp"
    case orders = "menuToOrdersView"
    case buy = "menuToBuyAgain"
}

class MenuViewController: UIViewController {
    
    var userProfileModel:UserProfileModel?
    let sIdentifier = SIdentifier.self
    var apiCaller = APICaller()
    
    @IBOutlet weak var userFullName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        userFullName.text = userProfileModel?.name
        loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadProfile()
    }
    
    func loadProfile(){
        apiCaller.getUserProfile(userId: UserDefaults.standard.integer(forKey: "Id")) { (userProfile) in
            DispatchQueue.main.async {
                self.userProfileModel = userProfile
                self.userFullName.text = userProfile.name
                print(userProfile)
                self.viewDidLoad()
            }
        }
    }
    
    
    
    @IBAction func userProfile(_ sender: Any) {
        performSegue(withIdentifier: sIdentifier.profile.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sIdentifier.profile.rawValue {
            guard let userProfileView = segue.destination as? UserProfileViewController else {
                return
            }
            userProfileView.userProfileModel = userProfileModel
        }
    }
    
    @IBAction func menuToBuyAgain(_ sender: Any) {
    }
    
    @IBAction func menuToOrders(_ sender: Any) {
        performSegue(withIdentifier: "menuToOrdersView", sender: nil)
    }
    
    @IBAction func menuToHelp(_ sender: Any) {
    }
    
    @IBAction func Logout(_ sender: Any) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removeObject(forKey: "Profile")
        UserDefaults.standard.removePersistentDomain(forName: domain)
        navigationController?.popToRootViewController(animated: true)
    }
    
}
