//
//  APIService.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/24/24.
//

import Foundation
import Alamofire

final class APIService {
    static let shared = APIService()

    private init() {}

    func searchPhoto(query: String, page: Int, sort: Sort, completion: @escaping (Result<ResultPhoto, Error>) -> Void) {
        let param: Parameters = [
            Constant.API.param.query: query,
            Constant.API.param.page: page,
            Constant.API.param.perPage: Constant.API.param.perPageValue,
            Constant.API.param.sort: sort.rawValue,
            Constant.API.param.key: APIKey.apiKey
        ]

        AF.request(BaseURL.search,
                   parameters: param
        )
        .responseDecodable(of: ResultPhoto.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
