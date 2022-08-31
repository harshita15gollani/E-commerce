//
//  GetRequests.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 29/07/22.
//

import Foundation
class APICaller {
    let userURL = "http://10.20.4.130:8093/login/users/"
    
    func getUserProfile(userId:Int,completion: @escaping (UserProfileModel)->()){
        let userId = String(userId)
        let escapedString = userId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let url = URL(string: "\(userURL)\(escapedString!)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ [weak self](data,response,error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do{
                        let responseData = try decoder.decode(UserProfileModel?.self, from: safeData)
                        completion(responseData!)
                        return
                    } catch {
                        print("Error Parsing Data")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func getListOfProducts(completion: @escaping ([ProductModel]?)->()){
        if let url = URL(string: "http://10.20.4.130:8084/product/catalog/newarrivals"){
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
    
    func updateProfile(userProfile : UserProfileModel, completion: @escaping (UserProfileModel)->()) {
        let session = URLSession.shared
        let url = URL(string: "http://10.20.4.130:8084/User/update")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(userProfile)
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
                let serverResponse = try decoder.decode(UserProfileModel.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
      }
    
    func getSearchResult(query:String, completion: @escaping ([ProductModel]?)->()){
        let baseURL = "http://localhost:9090/search/findall/"
        let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let url = URL(string: "\(baseURL)\(escapedString!)"){
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
        } else {
            print(URL(string: "\(baseURL)\(escapedString!)"))
        }
    }
    
    func getProductsByBrand(brand:String, completion: @escaping ([ProductModel]?)->()){
        let escapedString = brand.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let url = URL(string: "http://localhost:9090/search/findall/brand/\(escapedString!)"){
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
}
    
//    func updateUserInfo(userDataModel:UserUpdateModel,completion: @escaping (Bool)->()){
//        print(userURL)
//        let url = URL(string: "\(userURL)update")
//        print(url)
//        let session = URLSession.shared
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        do {
//            let encoder = JSONEncoder()
//            request.httpBody = try encoder.encode(userDataModel)
//        } catch let error {
//            print(error.localizedDescription)
//            return
//        }
//        let task = session.dataTask(with: request) { data, response, error in
//            
//            if let error = error {
//                print("Post Request Error: \(error.localizedDescription)")
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode)
//            else {
//                print("Invalid Response received from the server")
//                return
//            }
//            guard let responseData = data else {
//                print("nil Data received from the server")
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let serverResponse = try decoder.decode(UserLoginModel.self, from: responseData)
//                print(serverResponse)
//                completion(true)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }

