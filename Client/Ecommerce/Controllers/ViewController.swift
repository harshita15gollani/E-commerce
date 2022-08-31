//
//  ViewController.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 26/07/22.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginSignupSegment: UISegmentedControl!
    @IBOutlet weak var homescreenImage: UIImageView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //Signup Field Outlets
    @IBOutlet weak var userNameSignup: UITextField!
    @IBOutlet weak var emailSignup: UITextField!
    @IBOutlet weak var mobileNumberSignup: UITextField!
    @IBOutlet weak var fullNameSignup: UITextField!
    @IBOutlet weak var passwordSignup: UITextField!
    
    //Login Outlets
    @IBOutlet weak var userNameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    
    var userRegistrationAPI = UserRegistrationAPI()
    var userLoginAPI = UserLoginAPI()
    var apiCaller = APICaller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentInitilizerSetup()
        homeScreenImageLoader()
        assignTextFieldDelegates()
        loginSignupInitilizer()
        if UserDefaults.standard.integer(forKey: "Id") > 0{
            performSegue(withIdentifier: "loginToCatelogView", sender: nil)
        }
    }
    
    func assignTextFieldDelegates() {
        emailSignup.delegate = self
        emailSignup.becomeFirstResponder()
        emailSignup.keyboardType = .emailAddress
        mobileNumberSignup.keyboardType = .phonePad
        passwordSignup.isSecureTextEntry = true
        passwordLogin.isSecureTextEntry = true
    }
    
    func loginSignupInitilizer(){
        activityIndicator.isHidden = true
        loginView.isHidden = false
        signupView.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func segmentInitilizerSetup() {
        loginSignupSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func homeScreenImageLoader() {
        homescreenImage.image = UIImage(named: "/Users/jogireddy/Downloads/welcome.png")
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            loginView.isHidden = false
            signupView.isHidden = true
            signupView.endEditing(true)
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            loginView.isHidden = true
            signupView.isHidden = false
            loginView.endEditing(true)
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        //Validations of Input Date
        if validateAllFields(){
            let userProfile = UserProfileModel(id: 0, name: fullNameSignup.text!, userName: userNameSignup.text!, password: passwordSignup.text!, number: mobileNumberSignup.text!, email: emailSignup.text!, address: nil, dateOfBirth: nil, gender: nil, merchant: nil)
            userRegistrationAPI.postRequest(userData: userProfile) { (status) in
                DispatchQueue.main.async {
                    if status{
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        print("Created User Successfully \(#function)")
                        let alertController = UIAlertController(title: "Account Status", message: "Account Created Successfully Click OK to Login", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) {
                            (action: UIAlertAction!) in
                            self.fullNameSignup.text = ""
                            self.userNameSignup.text = ""
                            self.mobileNumberSignup.text = ""
                            self.passwordSignup.text = ""
                            self.emailSignup.text = ""
                            self.loginSignupSegment.selectedSegmentIndex = 0
                            self.viewDidLoad()
                            print("Ok button tapped");
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.viewDidLoad()
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        let alertController = UIAlertController(title: "Account Status", message: "Failed to Create Account Try Again", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) {
                            (action: UIAlertAction!) in
                            print("Ok button tapped");
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.viewDidLoad()
                        print("Failed to Create User Account")
                    }
                }
            }
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let username = userNameLogin.text,let password = passwordLogin.text {
            if username == "" || password == "" {
                self.invokeAlert(message: "Invalid Username or password")
            } else {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                let loginData = UserLoginModel(id: 0, userName: username, password: password, merchant: false)
                userLoginAPI.loginRequest(userLoginModel: loginData) { (serverResponse) in
                    DispatchQueue.main.async {
                        if serverResponse.id! > 0{
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            UserDefaults.standard.set(serverResponse.id!,forKey: "Id")
                            self.passwordLogin.text = nil
                            self.userNameLogin.text = nil
                            self.performSegue(withIdentifier: "loginToCatelogView", sender: nil)
                        }else {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.invokeAlert(message: "Invalid Username or Password")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Validation Method
    
    func validateAllFields()-> Bool {
        let validate = ValidationMethods()
        if let username = userNameSignup.text , validate.validateUserName(userName: username){
            if let email = emailSignup.text,validate.validateEmail(email: email) {
                if let password = passwordSignup.text,validate.validatePassword(password: password) {
                    if let mobile = mobileNumberSignup.text,validate.validateMobile(mobile: mobile) {
                        if let name = fullNameSignup.text,name != "" {
                            return true
                        }
                        self.invokeAlert(message: "Invalid Full Name")
                        print("Please Enter Valid Name")
                    }
                    self.invokeAlert(message: "Invalid Mobile Number")
                    print("Please Enter a Valid Mobile Number")
                }
                self.invokeAlert(message: "Invalid Password it must Contain minimum 8 Character with at least 1 Uppercase 1 Lower case 1 Numeric and 1 Special Character")
                print("Please Enter a valid Password")
            }
            self.invokeAlert(message: "Invalid Email Please check and Try again")
            print("Please Enter a valid Email")
            return false
        }
        self.invokeAlert(message: "Invalid Username")
        return false
    }
    
    func invokeAlert(message:String) {
        let alertController = UIAlertController(title: "Validation Issue", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Load Profile
    
    /*
     func loadFullProfile() {
     let userId = UserDefaults.standard.integer(forKey: "Id")
     apiCaller.getUserProfile(userId: userId) { (userProfile) in
     DispatchQueue.main.async {
     let encoder = JSONEncoder()
     do{
     try UserDefaults.standard.set(encoder.encode(userProfile),forKey: "Profile")
     } catch {
     print(userProfile)
     }
     }
     }
     }
     */
    
    
    //Signup
    
    /*
     if validateAllFields(){
     let userProfileModel = UserProfileModel(name: fullNameSignup.text!, userName: userNameSignup.text!, password: passwordSignup.text!, number: mobileNumberSignup.text!, email: emailSignup.text!,address: nil,dateOfBirth: nil,gender: nil)
     userRegistrationAPI.postRequest(userData: userProfileModel) { (registrationStatus) in
     DispatchQueue.main.async {
     if registrationStatus{
     self.navigationController?.popToRootViewController(animated: true)
     print("User Created")
     } else {
     print("Failed to Create User")
     }
     }
     }
     }
     */
    
    
    // loginAction
    
    /*
     if let userName = userNameLogin.text,let password = passwordLogin.text {
     let userLoginModel = UserLoginModel(id: 0, userName: userName, password: password, merchant: false)
     userLoginAPI.loginRequest(userLoginModel: userLoginModel) { (serverResponse) in
     DispatchQueue.main.async {
     if let userId = serverResponse.id {
     UserDefaults.standard.set(userId,forKey: "Id")
     self.passwordLogin.text = nil
     self.userNameLogin.text = nil
     self.loadFullProfile()
     self.performSegue(withIdentifier: "loginToCatelogView", sender: nil)
     } else {
     UserDefaults.standard.removeObject(forKey: "Id")
     }
     }
     }
     }
     */
    
    
    /* Alert Functionality
     
     print("Created User Successfully \(#function)")
     let alertController = UIAlertController(title: "Alert", message: "Account Created Successfully", preferredStyle: .alert)
     let OKAction = UIAlertAction(title: "OK", style: .default) {
     (action: UIAlertAction!) in
     // Code in this block will trigger when OK button tapped.
     print("Ok button tapped");
     }
     alertController.addAction(OKAction)
     self.present(alertController, animated: true, completion: nil)
     
     */
    
}
