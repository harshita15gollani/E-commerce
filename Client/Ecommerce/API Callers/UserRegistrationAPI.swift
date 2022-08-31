//
//  UserRegistrationAPI.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 26/07/22.
//

import Foundation

class UserRegistrationAPI {
    
    func postRequest(userData: UserProfileModel,completion: @escaping (_ status:Bool)->()) {
      
      let url = URL(string: "http://10.20.4.130:8093/login/register")!
      let session = URLSession.shared
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(userData)
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
          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
            print(jsonResponse)
            DispatchQueue.main.async {
                completion(true)
            }
          } else {
            print("data maybe corrupted or in wrong format")
            throw URLError(.badServerResponse)
          }
        } catch let error {
          print(error.localizedDescription)
        }
      }
      task.resume()
    }
}
