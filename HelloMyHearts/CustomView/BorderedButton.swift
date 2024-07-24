//
//  BorderedButton.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

class BorderedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = configureButton()
        layer.shadowColor = Constant.Color.secondaryGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureButton() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.bordered()
        configuration.cornerStyle = .capsule
        configuration.image = Sort.image
        configuration.imagePadding = 5
        configuration.baseBackgroundColor = Constant.Color.primary
        configuration.baseForegroundColor = Constant.Color.secondary

        var titleAttr = AttributedString.init(Sort.latest.title)
        titleAttr.font = .boldSystemFont(ofSize: 15)
        configuration.attributedTitle = titleAttr
        return configuration
    }
}
