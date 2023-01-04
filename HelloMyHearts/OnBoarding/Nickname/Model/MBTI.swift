//
//  MBTI.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/28/24.
//

import UIKit

enum MBTI {
    static let mbti = "MBTI"
    static let mbtiList = ["E", "S", "T", "J", "I", "N", "F", "P"]

    case isSelected
    case unSelected

    var borderWidth: CGFloat {
        switch self {
        case .isSelected:
            return 0
        case .unSelected:
            return 1
        }
    }

    var borderColor: CGColor {
        switch self {
        case .isSelected:
            return Constant.Color.accent.cgColor
        case .unSelected:
            return Constant.Color.secondaryGray.cgColor
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .isSelected:
            return Constant.Color.accent
        case .unSelected:
            return Constant.Color.primary
        }
    }

    var textColor: UIColor {
        switch self {
        case .isSelected:
            return Constant.Color.primary
        case .unSelected:
            return Constant.Color.secondaryGray
        }
    }
}
