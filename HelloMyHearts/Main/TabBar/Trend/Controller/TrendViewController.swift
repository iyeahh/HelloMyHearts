//
//  TrendViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit

final class TrendViewController: BaseViewController {
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

    var imageList: [[TopicPhoto]] = [[], [], []]

    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }

    override func configureHierarchy() {
        view.addSubview(largeTitleLabel)
        view.addSubview(tableView)
    }

    override func configureLayout() {
        largeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(largeTitleLabel.snp.bottom)
        }
    }

    private func callRequest() {
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global().async(group: group) {
            APIService.shared.fetchTopicPhoto(topic: "golden-hour") { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let success):
                    imageList[0] = success
                case .failure(let failure):
                    print(failure)
                }
                group.leave()
            }
        }

        group.enter()
        DispatchQueue.global().async(group: group) {
            APIService.shared.fetchTopicPhoto(topic: "business-work") { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let success):
                    print(success)
                    imageList[1] = success
                case .failure(let failure):
                    print(failure)
                }
                group.leave()
            }
        }

        group.enter()
        DispatchQueue.global().async(group: group) {
            APIService.shared.fetchTopicPhoto(topic: "architecture-interior") { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let success):
                    print(success)
                    imageList[2] = success
                case .failure(let failure):
                    print(failure)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
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
        let title = [
            Constant.LiteralString.Topic.goldenHour,
            Constant.LiteralString.Topic.business,
            Constant.LiteralString.Topic.interior
        ]

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
        cell.configureData(photo: data)
        return cell
    }
}
