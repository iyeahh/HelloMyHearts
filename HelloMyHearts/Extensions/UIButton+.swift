//
//  UIButton+.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/28/24.
//

import UIKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
