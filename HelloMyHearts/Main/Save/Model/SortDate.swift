//
//  SortDate.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import Foundation

enum SortDate {
    case latest
    case oldest

    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .oldest:
            return "과거순"
        }
    }
}
