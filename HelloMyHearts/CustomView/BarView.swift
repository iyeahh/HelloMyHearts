//
//  BarView.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

class BarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constant.Color.secondaryLightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
