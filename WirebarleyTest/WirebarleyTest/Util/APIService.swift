//
//  APIService.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation

enum NetworkError: Error {
    case responseError
    case noData
}

let url = "http://api.currencylayer.com/live?access_key=7063bbdf25d9f939368df1c8087adde1"

class APIService {
    static let shared = APIService()
    
    func request(urlString: String, body: Data? = nil, completion: @escaping (Result<Data, NetworkError>)-> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
        
    }
}
