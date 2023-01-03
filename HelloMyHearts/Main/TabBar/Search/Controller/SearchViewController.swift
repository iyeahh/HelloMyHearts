//
//  SearchViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit
import Toast

final class SearchViewController: BaseViewController {
    private let topBarView = BarView()

    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constant.LiteralString.Search.placeholder
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private lazy var sortButton = {
        let button = BorderedButton()
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

    private var searchPhoto = SearchPhoto()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    override func configureNavi() {
        navigationItem.title = TabBar.search.rawValue
    }

    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(topBarView)
        view.addSubview(sortButton)
        view.addSubview(bottomBarView)
        view.addSubview(collectionView)
        view.addSubview(descriptionLabel)
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
        }

        topBarView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
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

extension SearchViewController {
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
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }

    @objc private func sortButtonTapped() {
        searchPhoto.sort.toggle()
        sortButton.titleConfiuration(title: searchPhoto.sortValue.title)
        callRequest()
    }

    private func callRequest() {
        APIService.shared.callRequest(api: .search(query: searchPhoto.searhWord, page: searchPhoto.page, sort: searchPhoto.sortValue)) { [weak self] (response: Result<ResultPhoto, Error>) in
            guard let self else { return }

            switch response {
            case .success(let success):
                guard !success.results.isEmpty else {
                    collectionView.isHidden = true
                    descriptionLabel.text = Constant.LiteralString.Search.EmptyDescription.result
                    return
                }

                collectionView.isHidden = false
                descriptionLabel.text = ""

                if searchPhoto.page == 1 {
                    searchPhoto.photoList = success.results
                } else {
                    searchPhoto.photoList.append(contentsOf: success.results)
                }

                if searchPhoto.page == success.total_pages {
                    searchPhoto.isEnd = true
                }

                collectionView.reloadData()
                if searchPhoto.page == 1 {
                    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPhoto.photoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let photo = searchPhoto.photoList[indexPath.item]

        cell.addLike = { [weak self] in
            guard let self else { return }
            cell.isLike.toggle()
            if cell.isLike {
                view.makeToast(Constant.LiteralString.ToastMessage.addLike, duration: Constant.LiteralNumber.toastDuration)
                DocumentManager.shared.saveImageToDocument(urlString: photo.urls.small, id: photo.id)
                LikeTabelRepository.shared.createLike(photo: photo)
            } else {
                view.makeToast(Constant.LiteralString.ToastMessage.removeLike, duration: Constant.LiteralNumber.toastDuration)
                DocumentManager.shared.removeImageFromDocument(id: photo.id)
                LikeTabelRepository.shared.deleteLike(id: photo.id)
            }
        }
        cell.configureData(photo: photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if searchPhoto.photoList.count - 4 == item.row && !searchPhoto.isEnd {
                searchPhoto.page += 1
                callRequest()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveNextVC(vc: DetailViewController(photo: searchPhoto.photoList[indexPath.item]))
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchPhoto.page = 1
        searchPhoto.searhWord = text
        callRequest()
    }
}
