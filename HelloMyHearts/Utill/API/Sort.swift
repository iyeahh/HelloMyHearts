//
//  Sort.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

enum Sort: String {
    static let image = UIImage(named: "sort")

    case latest
    case releveant

    var title: String {
        switch self {
        case .latest:
            return "관련순"
        case .releveant:
            return "최신순"
        }
    }
}
