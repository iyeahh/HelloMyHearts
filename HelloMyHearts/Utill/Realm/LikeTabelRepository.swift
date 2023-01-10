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

    func createLike(photo: Photo) {
        let data = LikeTable(
            id: photo.id,
            createdDate: photo.created_at,
            width: photo.width,
            height: photo.height,
            url: photo.urls.raw,
            likes: photo.likes,
            photographerName: photo.user.name,
            photographerProfileImage: photo.user.profile_image.medium
        )

        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("좋아요 저장이 되지 않았어요")
        }
    }

    func readLike() -> [LikeTable] {
        let list = realm.objects(LikeTable.self)
        return list.sorted {
            $0.regDate > $1.regDate
        }
    }

    func checkIsLike(id: String) -> Bool {
        let data = readLike().filter {
            $0.id == id
        }

        if data.count == 0 {
            return false
        } else {
            return true
        }
    }

    func deleteLike(id: String) {
        let data = readLike().filter {
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

    func sortDate(standard: SortDate) -> [LikeTable] {
        let list = readLike()
        if standard == .latest {
            return list.sorted {
                $0.regDate > $1.regDate
            }
        } else {
            return list.sorted {
                $0.regDate < $1.regDate
            }
        }
    }
}
