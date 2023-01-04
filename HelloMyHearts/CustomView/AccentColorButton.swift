//
//  AccentColorButton.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit

final class AccentColorButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = Constant.LiteralNumber.cornerRadius
        backgroundColor = Constant.Color.accent
        titleLabel?.font = Constant.Font.bold15
        setTitleColor(Constant.Color.primary, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
