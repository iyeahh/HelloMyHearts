//
//  TextAlignmentRightLabel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import UIKit

class TextAlignmentRightLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .right
        font = Constant.Font.system13
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
