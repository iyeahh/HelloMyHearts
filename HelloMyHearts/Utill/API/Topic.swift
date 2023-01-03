//
//  Topic.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import Foundation

enum Topic: Int, CaseIterable {
    case goldenHour
    case business
    case interior

    var topic: String {
        switch self {
        case .goldenHour:
            return "golden-hour"
        case .business:
            return "business-work"
        case .interior:
            return "architecture-interior"
        }
    }

    var title: String {
        switch self {
        case .goldenHour:
            return "골든 아워"
        case .business:
            return "비즈니스 및 업무"
        case .interior:
            return "건축 및 인테리어"
        }
    }
}
