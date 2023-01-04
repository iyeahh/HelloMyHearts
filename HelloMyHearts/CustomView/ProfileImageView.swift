//
//  ProfileImageView.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        layer.borderColor = ProfileImageType.isSelected.borderSetting.color
        layer.borderWidth = Constant.LiteralNumber.border
        alpha = ProfileImageType.isSelected.borderSetting.alpha
        layer.masksToBounds = true
        contentMode = .scaleAspectFit
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
