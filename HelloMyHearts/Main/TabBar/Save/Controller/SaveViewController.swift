//
//  SaveViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit
import RealmSwift

final class SaveViewController: BaseViewController {
    private let topBarView = BarView()

    private lazy var sortButton = {
        let button = BorderedButton()
        button.titleConfiuration(title: SortDate.latest.title)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()

    private let descriptionLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private let bottomBarView = BarView()

    private var likePhotoList: [LikeTable] = [] {
        didSet {
            if likePhotoList.count == 0 {
                descriptionLabel.text = "저장된 사진이 없어요"
            } else {
                descriptionLabel.text = ""
            }
            collectionView.reloadData()
        }
    }

    private var sort = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        likePhotoList = LikeTabelRepository.shared.readLike()
    }

    override func configureNavi() {
        navigationItem.title = TabBar.save.rawValue
    }

    override func configureHierarchy() {
        view.addSubview(topBarView)
        view.addSubview(sortButton)
        view.addSubview(bottomBarView)
        view.addSubview(collectionView)
        view.addSubview(descriptionLabel)
    }

    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        sortButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(topBarView.snp.bottom).offset(5)
        }

        bottomBarView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(sortButton.snp.bottom).offset(5)
            make.bottom.equalTo(bottomBarView.snp.top)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}

extension SaveViewController {
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 5) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }

    @objc private func sortButtonTapped() {
        sort.toggle()
        let sortValue: SortDate
        if sort {
            sortValue = .latest
        } else {
            sortValue = .oldest
        }

        sortButton.titleConfiuration(title: sortValue.title)
        likePhotoList = LikeTabelRepository.shared.sortDate(standard: sortValue)
    }
}

extension SaveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likePhotoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let photo = likePhotoList[indexPath.item]
        let image = DocumentManager.shared.loadImageToDocument(id: photo.id)

        cell.addLike = { [weak self] in
            guard let self else { return }
            cell.isLike.toggle()
            if !cell.isLike {
                view.makeToast(Constant.LiteralString.ToastMessage.removeLike, duration: Constant.LiteralNumber.toastDuration)
                DocumentManager.shared.removeImageFromDocument(id: photo.id)
                LikeTabelRepository.shared.deleteLike(id: photo.id)
                likePhotoList = LikeTabelRepository.shared.readLike()
            }
        }
        cell.configureData(image: image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = likePhotoList[indexPath.item]
        let photo = Photo(id: data.id, created_at: data.createdDate, width: data.width, height: data.height, urls: URLImage(raw: data.url, small: ""), likes: data.likes, user: Photographer(name: data.photographerName, profile_image: Profile(medium: data.photographerProfileImage)))
        moveNextVC(vc: DetailViewController(photo: photo))
    }
}
