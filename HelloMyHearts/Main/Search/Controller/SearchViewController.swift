//
//  SearchViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    private let topBarView = BarView()

    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constant.LiteralString.Search.placeholder
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private let sortButton = BorderedButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private let bottomBarView = BarView()

    var page = 1
    var list: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
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
    }
}

extension SearchViewController {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier)
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
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCollectionViewCell.identifier, for: indexPath) as? SearchPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configureData(photo: list[indexPath.item])
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        APIService.shared.searchPhoto(query: text, page: page, sort: .releveant) { [weak self] value in
            guard let self else { return }

            switch value {
            case .success(let success):
                self.list = success.results
                self.collectionView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
