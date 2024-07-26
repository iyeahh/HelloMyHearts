//
//  LikeTabelRepository.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/25/24.
//

import Foundation
import RealmSwift

final class LikeTabelRepository {
    static let shared = LikeTabelRepository()
    private let realm = try! Realm()

    private init() {}

    func createLike(id: String) {
        let data = LikeTable(id: id, regDate: Date())

        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("좋아요 저장이 되지 않았어요")
        }
    }

    func readLike() -> Results<LikeTable> {
        return realm.objects(LikeTable.self)
    }

    func checkIsLike(id: String) -> Bool {
        let data = readLike().where {
            $0.id == id
        }

        if data.count == 0 {
            return false
        } else {
            return true
        }
    }

    func deleteLike(id: String) {
        let data = readLike().where {
            $0.id == id
        }

        do {
            try realm.write {
                realm.delete(data[0])
            }
        } catch {
            print("좋아요 삭제가 되지 않았어요")
        }
    }
}
