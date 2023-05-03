//
//  ResultPhoto.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/24/24.
//

import Foundation

struct ResultPhoto: Decodable {
    let total_pages: Int
    let results: [Photo]
}

struct Photo: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: URLImage
    let likes: Int
    let user: Photographer
}

struct URLImage: Decodable {
    let raw: String
    let small: String
}

struct Photographer: Decodable {
    let name: String
    let profile_image: Profile
}

struct Profile: Decodable {
    let medium: String
}
