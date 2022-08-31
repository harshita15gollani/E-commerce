//
//  DataModel.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 26/07/22.
//

import Foundation

struct UserProfileModel : Codable {
    let id : Int?
    let name : String?
    let userName : String?
    let password : String?
    let number : String?
    let email : String?
    let address : String?
    let dateOfBirth : String?
    let gender : String?
    let merchant : Bool?
}


struct UserLoginModel : Codable {
    let id : Int?
    let userName : String?
    let password : String?
    let merchant : Bool?
}

struct ProductModel : Codable {
    let id : Int?
    let image : [String]?
    var quantity : Int?
    let timeStamp : String?
    let title : String?
    let merchant_id : Int?
    let description : String?
    let category : String?
    let price : Int?
    let stock : Int?
    let rating : Double?
    let brand : String?
    let color : String?
    let processor : String?
    let size : String?
    let ram : String?
    let refreshRate : String?
    let screenSize : String?
    let connectionType : String?
    let videoCaptureResolution : String?
    let imageCaptureResolution :String?
    let captureSpeed : String?
}


// Add to cart
// /cart to add
// /cart/{userid}
// /cart/quantity

struct CartModel : Codable {
    let id : Int?
    let userId : Int?
    let productId : Int?
    let quantity : Int?
    let price : Int?
    let merchantId : Int?
}

struct totalPrice : Codable {
    let userId : Int?
    let totalBill : Int?
    let products : [CheckoutModel]?
}

struct CheckoutModel : Codable {
    let title : String?
    let quantity : Int?
    let price : Int?
    let totalPrice : Int?
}



//struct UserUpdateModel : Codable {
//    let id : Int?
//    let name : String?
//    let userName : String?
//    let password : String?
//    let email : String?
//    let address : String?
//    let gender : String?
//    let dataOfBirth : Date?
//    let number : String?
//}
