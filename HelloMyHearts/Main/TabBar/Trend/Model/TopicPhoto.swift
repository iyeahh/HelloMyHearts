//
//  TopicPhoto.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import Foundation

struct TopicPhoto: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: URLPhoto
    let likes: Int
    let user: PhotoGrapher
}

struct URLPhoto: Decodable {
    let raw: String
    let small: String
}

struct PhotoGrapher: Decodable {
    let name: String
    let profile_image: ProfileImage
}

struct ProfileImage: Decodable {
    let medium: String
}
