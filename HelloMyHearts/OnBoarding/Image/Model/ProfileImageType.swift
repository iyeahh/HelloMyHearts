//
//  ProfileImageType.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit

enum ProfileImageType {
    case isSelected
    case unSelected

    var borderSetting: (borderWidth: CGFloat, alpha: CGFloat, color: CGColor) {
        switch self {
        case .isSelected:
            return (3, 1, Constant.Color.accent.cgColor)
        case .unSelected:
            return (1, 0.5, Constant.Color.secondaryGray.cgColor)
        }
    }
}
