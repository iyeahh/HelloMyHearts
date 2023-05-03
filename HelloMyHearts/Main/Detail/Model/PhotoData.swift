//
//  PhotoData.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import Foundation

struct PhotoData: Decodable {
    let id: String
    let downloads: Datas
    let views: Datas
}

struct Datas: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [Value]
}

struct Value: Decodable {
    let date: String
    let value: Int
}
