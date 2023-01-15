//
//  TrendViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit

final class TrendViewController: BaseViewController {
    private let profileImageView = {
        let imageView = ProfileImageView()
        imageView.layer.borderWidth = 3
        return imageView
    }()

    private lazy var profileButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()

    private let largeTitleLabel = {
        let label = UILabel()
        label.text = TabBar.trend.rawValue
        label.font = Constant.Font.bold32
        return label
    }()

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = ((UIScreen.main.bounds.width - 10) / 2 * 1.3) + 50
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        return tableView
    }()

    var imageList: [[Photo]] = [[], [], []]

    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        setProfileImageView()
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    override func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(profileButton)
        view.addSubview(largeTitleLabel)
        view.addSubview(tableView)
    }

    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }

        profileButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
        }

        largeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }

        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(largeTitleLabel.snp.bottom)
        }
    }

    private func callRequest() {
        let group = DispatchGroup()

        Topic.allCases.forEach { topic in
            group.enter()
            DispatchQueue.global().async(group: group) {
                APIService.shared.callRequest(api: .fetchTopicPhoto(topic: topic)) { [weak self] (response: Result<[Photo], NetworkError>) in
                    guard let self else { return }
                    switch response {
                    case .success(let success):
                        imageList[topic.rawValue] = success
                    case .failure(let failure):
                        switch failure {
                        case .unstableStatus:
                            DispatchQueue.main.async { [weak self] in
                                guard let self else { return }
                                view.makeToast(Constant.LiteralString.ErrorMessage.unstableStatus)
                            }
                        case .failedResponse:
                            print(Constant.LiteralString.ErrorMessage.failedResponse)
                        }
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }

    func setProfileImageView() {
        if let image = UserDefaultsManager.shared.getValue(key: .image),
           let intImage = Int(image) {
            profileImageView.image = UIImage.getProfileImage(intImage)
        }
    }

    @objc private func profileButtonTapped() {
        let editProfileVC = SetNicknameViewConroller(state: .edit)
        moveNextVC(vc: editProfileVC)
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as? TrendTableViewCell else {
            return UITableViewCell()
        }
        let title = Topic.allCases.map { topic in
            topic.title
        }

        cell.setTitle(title[indexPath.row])

        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.row
        cell.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cell.collectionView.reloadData()
        return cell
    }
}

extension TrendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let data = imageList[collectionView.tag][indexPath.item]
        cell.configureData(topicPhoto: data)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = imageList[collectionView.tag][indexPath.item]
        moveNextVC(vc: DetailViewController(photo: data))
    }
}
