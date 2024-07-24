//
//  ResultPhoto.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/24/24.
//

import Foundation

struct ResultPhoto: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}

struct Photo: Decodable {
    let likes: Int
    let urls: URL
}

struct URL: Decodable {
    let raw: String
    let small: String
}
