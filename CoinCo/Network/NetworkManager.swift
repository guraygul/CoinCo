//
//  NetworkManager.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private init() {}
    
    func request<T: Decodable>(
        request: URLRequestConvertible,
        decodeType type: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void) {
            AF.request(request).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(decodedData))
                        
                    } catch {
                        print("JSON decoding error: \(error)")
                    }
                case .failure(let error):
                    completionHandler(.failure(error.localizedDescription as! Error))
                }
            }
        }
}
