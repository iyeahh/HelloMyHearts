//
//  SetImageCollectionViewCell.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit
import SnapKit

final class SetImageCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = ProfileImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
    }

    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(profileImageView.snp.width)
        }
    }
}

extension SetImageCollectionViewCell {
    func configureImage(_ image: Int, type: ProfileImageType) {
        profileImageView.image = UIImage.getProfileImage(image)
        profileImageView.layer.borderColor = type.borderSetting.color
        profileImageView.layer.borderWidth = type.borderSetting.borderWidth
        profileImageView.alpha = type.borderSetting.alpha
    }
}
