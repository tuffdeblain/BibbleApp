//
//  NetworkManager.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import Foundation
import Alamofire

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func request(url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
}
