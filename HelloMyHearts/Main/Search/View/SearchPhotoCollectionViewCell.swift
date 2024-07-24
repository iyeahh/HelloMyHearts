//
//  SearchPhotoCollectionViewCell.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit

final class SearchPhotoCollectionViewCell: BaseCollectionViewCell {
    private let mainImageView = UIImageView()
    private let likeCountLabel = GrayBackgroundView()
    private let likeButton = UIButton()

    override func configureHierarchy() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(likeButton)
    }

    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likeCountLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(25)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
            make.size.equalTo(35)
        }
    }

    override func configureData() {
        mainImageView.backgroundColor = .systemGreen
        likeCountLabel.numberLabel.text = "3929"
        likeButton.setImage(Constant.Image.Icon.Like.circleLikeInactive, for: .normal)
    }
}
