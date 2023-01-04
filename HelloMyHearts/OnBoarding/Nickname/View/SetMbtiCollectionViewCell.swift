//
//  SetMbtiCollectionViewCell.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/28/24.
//

import UIKit
import SnapKit

final class SetMbtiCollectionViewCell: BaseCollectionViewCell {
    private let mbtiLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        mbtiLabel.layoutIfNeeded()
        mbtiLabel.layer.masksToBounds = true
        mbtiLabel.layer.cornerRadius = mbtiLabel.frame.width / 2
    }

    override func configureHierarchy() {
        contentView.addSubview(mbtiLabel)
    }

    override func configureLayout() {
        mbtiLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(mbtiLabel.snp.width)
        }
    }
}

extension SetMbtiCollectionViewCell {
    private func configureCell(type: MBTI) {
        mbtiLabel.backgroundColor = type.backgroundColor
        mbtiLabel.textColor = type.textColor
        mbtiLabel.layer.borderWidth = type.borderWidth
        mbtiLabel.layer.borderColor = type.borderColor
    }

    func configureData(title: String, type: MBTI) {
        mbtiLabel.text = title
        configureCell(type: type)
    }
}
