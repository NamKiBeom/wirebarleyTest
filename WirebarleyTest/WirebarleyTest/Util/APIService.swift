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

protocol FetchAPIData {
    func request(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class APIService: FetchAPIData {
    func request(urlString: String, completion: @escaping (Result<Data, NetworkError>)-> Void) {
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
