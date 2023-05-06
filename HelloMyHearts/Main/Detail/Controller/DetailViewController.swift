//
//  DetailViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: BaseViewController {
    private let topBarView = BarView()

    private let profileImageView = UIImageView()

    private let nameLable = {
        let label = UILabel()
        label.font = Constant.Font.system13
        return label
    }()

    private let regDateLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold11
        return label
    }()

    private lazy var likeButton = {
        let button = UIButton()
        button.setImage(Constant.Image.Icon.Like.likeInactive, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let imageView = UIImageView()

    private let informataionLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold17
        label.text = Constant.LiteralString.Detail.information
        return label
    }()

    private let sizeLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.size)
        return label
    }()

    private let viewsLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.views)
        return label
    }()

    private let downloadLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.downloads)
        return label
    }()

    private let sizeDataLabel = TextAlignmentRightLabel()
    private let viewsDataLabel = TextAlignmentRightLabel()
    private let downloadDataLabel = TextAlignmentRightLabel()

    let viewModel = DetailViewModel()

    init(photo: Photo) {
        viewModel.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoad.value = ()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    override func configureHierarchy() {
        [topBarView, profileImageView, nameLable, regDateLabel, likeButton, imageView, informataionLabel, sizeLabel, sizeDataLabel, viewsLabel, viewsDataLabel, downloadLabel, downloadDataLabel].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(topBarView.snp.bottom).offset(10)
            make.size.equalTo(40)
        }

        nameLable.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.top.equalTo(topBarView.snp.bottom).offset(15)
        }

        regDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.top.equalTo(nameLable.snp.bottom)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(topBarView.snp.bottom).offset(10)
            make.size.equalTo(40)
        }

        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(likeButton.snp.bottom).offset(10)
            make.height.equalToSuperview().dividedBy(4)
        }

        informataionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(imageView.snp.bottom).offset(15)
        }

        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.equalTo(informataionLabel.snp.trailing).offset(50)
        }

        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.leading.equalTo(informataionLabel.snp.trailing).offset(50)
        }

        downloadLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(10)
            make.leading.equalTo(informataionLabel.snp.trailing).offset(50)
        }

        sizeDataLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(sizeLabel)
        }

        viewsDataLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(viewsLabel)
        }

        downloadDataLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(downloadLabel)
        }
    }
}

extension DetailViewController {
    private func bindData() {
        viewModel.outputLikeToggle.bind { [weak self] value in
            guard let value,
                  let self else { return }

            if value {
                view.makeToast(Constant.LiteralString.ToastMessage.addLike, duration: Constant.LiteralNumber.toastDuration)
                likeButton.setImage(Constant.Image.Icon.Like.like, for: .normal)
            } else {
                view.makeToast(Constant.LiteralString.ToastMessage.removeLike, duration: Constant.LiteralNumber.toastDuration)
                likeButton.setImage(Constant.Image.Icon.Like.likeInactive, for: .normal)
            }
        }

        viewModel.outputPhotoData.bind { [weak self] photoData in
            guard let self,
                  let photoData else { return }
            viewsDataLabel.text = photoData.views.total.formatted()
            downloadDataLabel.text = photoData.downloads.total.formatted()
            setLabelData()
        }
    }

    private func setLabelData() {
        guard let photo = viewModel.photo,
              let profile = URL(string: photo.user.profile_image.medium),
              let image = URL(string: photo.urls.raw) else { return }
        profileImageView.kf.setImage(with: profile)
        nameLable.text = photo.user.name
        regDateLabel.text = DateFormatterManager.shared.dateFormat(photo.created_at)
        imageView.kf.setImage(with: image)
        sizeDataLabel.text = "\(photo.width) x \(photo.height)"
    }

    @objc private func likeButtonTapped() {
        viewModel.inputLikeToggle.value = ()
    }
}
