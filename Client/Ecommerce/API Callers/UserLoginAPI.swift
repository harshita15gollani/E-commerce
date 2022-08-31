//
//  UserLoginAPI.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import Foundation

class UserLoginAPI {
    let url = URL(string: "http://10.20.4.130:8093/login/validate/user")
    
    func loginRequest(userLoginModel: UserLoginModel, completion: @escaping (UserLoginModel)->()){
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(userLoginModel)
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
                let serverResponse = try decoder.decode(UserLoginModel.self, from: responseData)
                print(serverResponse)
                completion(serverResponse)
            } catch let error {
                completion(UserLoginModel(id: -1, userName: "", password: "", merchant: false))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
