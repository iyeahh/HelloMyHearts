//
//  URLComponent.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import Foundation
import Alamofire

enum URLComponent {
    case search(query: String, page: Int, sort: Sort)
    case fetchPhotoData(id: String)
    case fetchTopicPhoto(topic: Topic)

    private enum Param {
        static let query = "query"
        static let page = "page"
        static let perPage = "per_page"
        static let perPageValue = 20
        static let sort = "order_by"
        static let key = "client_id"
    }
}

extension URLComponent {
    var baseURL: String {
        return APIKey.baseURL
    }

    var path: String {
        switch self {
        case .search:
            return "search/photos?"
        case .fetchPhotoData(let id):
            return "photos/\(id)/statistics?"
        case .fetchTopicPhoto(let topic):
            return "topics/\(topic.topic)/photos?"
        }
    }

    var parameters: Parameters {
        switch self {
        case .search(let query, let page, let sort):
            return [
                Param.key: APIKey.apiKey,
                Param.query: query,
                Param.page: page,
                Param.perPage: Param.perPageValue,
                Param.sort: sort.rawValue
            ]
        case .fetchPhotoData, .fetchTopicPhoto:
            return [
                Param.key: APIKey.apiKey
            ]
        }
    }

    var url: String {
        return baseURL + path
    }
}
