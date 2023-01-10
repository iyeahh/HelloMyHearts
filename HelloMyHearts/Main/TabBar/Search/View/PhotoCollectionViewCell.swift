//
//  PhotoCollectionViewCell.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    private let mainImageView = UIImageView()
    private let likeCountLabel = GrayBackgroundView()
    private lazy var likeButton = {
        let button = UIButton()
        button.setImage(Constant.Image.Icon.Like.circleLikeInactive, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    var addLike: (()-> Void?)?
    var isLike = false {
        didSet {
            if isLike {
                likeButton.setImage(Constant.Image.Icon.Like.circleLike, for: .normal)
            } else {
                likeButton.setImage(Constant.Image.Icon.Like.circleLikeInactive, for: .normal)
            }
        }
    }

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

    func configureData(photo: Photo) {
        let url = URL(string: photo.urls.small)
        mainImageView.kf.setImage(with: url)
        likeCountLabel.setLabelText(photo.likes.formatted())
        if LikeTabelRepository.shared.checkIsLike(id: photo.id) {
            isLike = true
        } else {
            isLike = false
        }
    }

    func configureData(image: UIImage?) {
        guard let image else { return }
        mainImageView.image = image
        likeCountLabel.isHidden = true
        isLike = true
    }

    func configureData(topicPhoto: Photo) {
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.cornerRadius = 20
        let url = URL(string: topicPhoto.urls.small)
        mainImageView.kf.setImage(with: url)
        likeCountLabel.setLabelText(topicPhoto.likes.formatted())
        likeButton.isHidden = true
    }

    @objc private func likeButtonTapped() {
        addLike?()
    }
}
