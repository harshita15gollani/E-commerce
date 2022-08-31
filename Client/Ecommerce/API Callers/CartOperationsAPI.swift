//
//  CartOperationsAPI.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 30/07/22.
//

import Foundation

class CartOperationsAPI {
    let baseURL = "http://10.20.4.130:8095/cart/"
    
    func addToCart(cartModel : CartModel, completion: @escaping (CartModel?)->()) {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(cartModel)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let serverResponse = try decoder.decode(CartModel.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getCartProducts(userId:Int, completion: @escaping ([ProductModel]?)->()) {
        let id = String(userId)
        if let url = URL(string: "\(baseURL)\(id)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ [weak self](data,response,error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do{
                        let responseData = try decoder.decode([ProductModel]?.self, from: safeData)
                        completion(responseData)
                        return
                    } catch {
                        print("Error Parsing Data")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func updateCartQuantity (cartObj:CartModel,completion: @escaping (ProductModel?)->()){
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)quantity")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(cartObj)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let serverResponse = try decoder.decode(ProductModel?.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func deleteProductFromCart(cartObj:CartModel,completion: @escaping (String)->()) {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)delete")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(cartObj)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let serverResponse = try JSONSerialization.jsonObject(with: responseData) as? String
                print(serverResponse!)
                completion(serverResponse!)
            } catch let error {
                completion(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func placeOrder(billInvoice:totalPrice,completion: @escaping (String)->()) {
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let session = URLSession.shared
        let id = String(userId)
        let url = URL(string: "\(baseURL)placedall/\(id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) { data, response, error in
//            do {
//                let encoder = JSONEncoder()
//                request.httpBody = try encoder.encode(billInvoice)
//            } catch let error {
//                print(error.localizedDescription)
//                return
//            }
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let serverResponse = try decoder.decode(String.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                completion("Failed")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getOrderDetails(userId:Int, completion: @escaping ([ProductModel]?)->()) {
        let id = String(userId)
        if let url = URL(string: "http://10.20.4.130:8095/order/details/\(id)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ [weak self](data,response,error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do{
                        let responseData = try decoder.decode([ProductModel]?.self, from: safeData)
                        completion(responseData)
                        return
                    } catch {
                        print("Error Parsing Data")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    func placeSingleOrder (cartObj : CartModel, completion: @escaping (ProductModel)->()) {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)placed")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(cartObj)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let serverResponse = try decoder.decode(ProductModel.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
