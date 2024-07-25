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
    @Persisted var regDate: Date

    convenience init(id: String, regDate: Date) {
        self.init()
        self.id = id
        self.regDate = regDate
    }
}
