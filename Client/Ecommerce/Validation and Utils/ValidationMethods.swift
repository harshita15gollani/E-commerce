//
//  ValidationMethods.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import Foundation

class ValidationMethods {
    let userLoginAPI = UserLoginAPI()
    
    func validateEmail(email : String) -> Bool {
        let pattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let result = email.range(of: pattern, options: .regularExpression)
        if let _ = result {
            return true
        }
        return false
    }
    
    func validatePassword(password : String) -> Bool {
        let pattern = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        let result = password.range(of: pattern, options: .regularExpression)
        if let _ = result {
            return true
        }
        return false
    }
    
    func validateMobile(mobile : String) -> Bool {
        let pattern = "^([+]\\d{2})?\\d{10}$"
        let result = mobile.range(of: pattern,options: .regularExpression)
        if let _ = result {
            return true
        }
        return false
    }
    
    func validateUserName(userName : String) -> Bool {
        let pattern = "^[a-zA-Z0-9]([._-](?![._-])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$"
        let result = userName.range(of: pattern,options: .regularExpression)
        if let _ = result {
            return true
        }
        return false
    }

}
