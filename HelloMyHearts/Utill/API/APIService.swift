//
//  APIService.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/24/24.
//

import UIKit
import Alamofire

final class APIService {
    static let shared = APIService()

    private init() {}

    func callRequest<T: Decodable>(api: URLComponent, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard NetworkMonitor.shared.isConnected else {
            completion(.failure(.unstableStatus))
            return
        }

        AF.request(api.url,
                   parameters: api.parameters)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure:
                completion(.failure(.failedResponse))
            }
        }
    }
}
