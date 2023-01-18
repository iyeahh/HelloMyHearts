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

    let viewModel = TrendViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
        bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppear.value = ()
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

    @objc private func profileButtonTapped() {
        let editProfileVC = SetNicknameViewConroller(state: .edit)
        moveNextVC(vc: editProfileVC)
    }

    private func bindData() {
        viewModel.outputErrorToast.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            view.makeToast(Constant.LiteralString.ErrorMessage.unstableStatus)
        }

        viewModel.outputReloadTableView.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }

        viewModel.outputImage.bind { [weak self] value in
            guard let value,
                  let self else { return }
            profileImageView.image = UIImage.getProfileImage(value)
        }
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageList.count
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
        return viewModel.imageList[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let data = viewModel.imageList[collectionView.tag][indexPath.item]
        cell.configureData(topicPhoto: data)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.imageList[collectionView.tag][indexPath.item]
        moveNextVC(vc: DetailViewController(photo: data))
    }
}
