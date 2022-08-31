//
//  UserProfileViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 28/07/22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var userProfileModel:UserProfileModel?
    var apiCaller = APICaller()
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var dateOfBirth: UIDatePicker!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var mobile: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getFromServer()
    }
    
    func getFromServer() {
        let userId = UserDefaults.standard.integer(forKey: "Id")
        apiCaller.getUserProfile(userId: userId) { (newProfile) in
            DispatchQueue.main.async {
                self.userProfileModel = newProfile
                self.loadUserProfile()
            }
        }
    }
    
    func loadUserProfile() {
        if let profile = userProfileModel {

            fullName.text = profile.name
            fullName.isUserInteractionEnabled = false
            email.text = profile.email
            email.isUserInteractionEnabled = false
            mobile.text = profile.number
            mobile.isUserInteractionEnabled = false
            address.text = profile.address
            address.isUserInteractionEnabled = false
            genderSegment.isUserInteractionEnabled = false
            dateOfBirth.isUserInteractionEnabled = false
//            if let date = profile.dateOfBirth{
//            dateOfBirth.date = date
//            }
            if profile.gender == "Female"{
            genderSegment.selectedSegmentIndex = 1
            } else {
                genderSegment.selectedSegmentIndex = 0
            }
        }
    }
    
    @IBAction func updateUserData(_ sender: Any) {
        let userUpdated = UserProfileModel(id: userProfileModel?.id, name: fullName.text!, userName: userProfileModel?.userName, password: userProfileModel?.password, number: mobile.text!, email: email.text!, address: address.text!, dateOfBirth: nil, gender: nil, merchant: userProfileModel?.merchant)
        apiCaller.updateProfile(userProfile: userUpdated) { (userProfileUpdated) in
            DispatchQueue.main.async {
                self.userProfileModel = userProfileUpdated
                self.loadUserProfile()
            }
        }
    }
    @IBAction func editDetails(_ sender: Any) {
        fullName.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = true
        mobile.isUserInteractionEnabled = true
        address.isUserInteractionEnabled = true
        genderSegment.isUserInteractionEnabled = true
        dateOfBirth.isUserInteractionEnabled = true
        
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
