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
    let topBarView = BarView()

    let profileImageView = UIImageView()

    let nameLable = {
        let label = UILabel()
        label.font = Constant.Font.system13
        return label
    }()

    let regDateLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold11
        return label
    }()

    let likeButton = UIButton()
    let imageView = UIImageView()

    let informataionLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold17
        label.text = Constant.LiteralString.Detail.information
        return label
    }()

    let sizeLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.size)
        return label
    }()

    let viewsLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.views)
        return label
    }()

    let downloadLabel = {
        let label = Bold15FontLabel(title: Constant.LiteralString.Detail.downloads)
        return label
    }()

    let sizeDataLabel = TextAlignmentRightLabel()
    let viewsDataLabel = TextAlignmentRightLabel()
    let downloadDataLabel = TextAlignmentRightLabel()

    var photo: Photo

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
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
            make.trailing.equalToSuperview().offset(15)
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
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }

        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
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
    func setData() {
        APIService.shared.fetchPhotoData(id: photo.id) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let success):
                viewsDataLabel.text = success.views.total.formatted()
                downloadDataLabel.text = success.downloads.total.formatted()
                setLabelData()
            case .failure(let failure):
                print("네트워킹 실패")
            }
        }
    }

    private func setLabelData() {
        guard let profile = URL(string: photo.user.profile_image.medium),
              let image = URL(string: photo.urls.raw) else { return }
        profileImageView.kf.setImage(with: profile)
        nameLable.text = photo.user.name
        regDateLabel.text = DateFormatterManager.shared.dateFormat(photo.created_at)
        imageView.kf.setImage(with: image)
        sizeDataLabel.text = "\(photo.width) x \(photo.height)"
    }
}
