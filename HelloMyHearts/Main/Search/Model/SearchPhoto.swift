//
//  SearchPhoto.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import Foundation

struct SearchPhoto {
    var page = 1
    var list: [Photo] = []
    var isEnd = false
    var searhWord = ""

    var sort = true {
        didSet {
            if sort {
                sortValue = Sort.releveant
            } else {
                sortValue = Sort.latest
            }
        }
    }

    var sortValue = Sort.releveant
}
