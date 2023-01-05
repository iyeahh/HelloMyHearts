//
//  UserDefaultsManager.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import Foundation

final class UserDefaultsManager {
    enum UserDefultsKey: String {
        case image
        case tempImage
        case nickname
        case mbti
    }

    static let shared = UserDefaultsManager()

    private init() { }

    func setValue(key: UserDefultsKey, _ value: String) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func getValue(key: UserDefultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }

    var mbti: [Bool]? {
        get {
            UserDefaults.standard.array(forKey: UserDefultsKey.mbti.rawValue) as? [Bool]
        }

        set {
            UserDefaults.standard.set(newValue, forKey: UserDefultsKey.mbti.rawValue)
        }
    }
}

extension UserDefaultsManager {
    func removeAll() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }

    func getUserInfo() -> UserInfo? {
        guard let image = getValue(key: .image),
              let nickname = getValue(key: .nickname),
              let mbti = mbti else { return nil }

        return UserInfo(image: image, nickname: nickname, mbti: mbti)
    }

    func isLogined() -> Bool {
        guard getValue(key: .nickname) != nil else { return false }
        return true
    }

    func createUserInfo(nickname: String?, image: String, inputMbti: [Bool?]) {
        guard let nickname else { return }

        setValue(key: .nickname, nickname)
        setValue(key: .image, image)
        mbti = inputMbti.compactMap { $0 }
        remove(.tempImage)
    }

    func remove(_ key: UserDefultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
