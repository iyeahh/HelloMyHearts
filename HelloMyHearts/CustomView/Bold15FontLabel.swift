//
//  Bold15FontLabel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import UIKit

class Bold15FontLabel: UILabel {
    init(title: String) {
        super.init(frame: .zero)
        font = Constant.Font.bold15
        text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
