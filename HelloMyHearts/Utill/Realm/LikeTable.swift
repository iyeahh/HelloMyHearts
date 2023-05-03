//
//  LikeTable.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/25/24.
//

import Foundation
import RealmSwift

final class LikeTable: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var createdDate: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var url: String
    @Persisted var photographerName: String
    @Persisted var photographerProfileImage: String
    @Persisted var regDate: Date

    convenience init(
        id: String,
        createdDate: String,
        width: Int,
        height: Int,
        url: String,
        photographerName: String,
        photographerProfileImage: String
    ) {
        self.init()
        self.id = id
        self.createdDate = createdDate
        self.width = width
        self.height = height
        self.url = url
        self.photographerName = photographerName
        self.photographerProfileImage = photographerProfileImage
        self.regDate = Date()
    }
}
