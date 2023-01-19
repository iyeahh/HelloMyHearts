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
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        viewModel.inputViewDidLoad.value = searchBar.text
        bindData()
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
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }

    @objc private func sortButtonTapped() {
        viewModel.inputSortButtonTapped.value = ()
    }
}

extension SearchViewController {
    private func bindData() {
        viewModel.outputPhotoList.bind { [weak self] _ in
            guard let self else { return }
            collectionView.reloadData()
        }

        viewModel.outputSortButtonTitle.bind { [weak self] value in
            guard let value,
                  let self else { return }
            sortButton.titleConfiuration(title: value)
        }

        viewModel.outputToastMessage.bind { [weak self] value in
            guard let value,
                  let self else { return }
            if value {
                view.makeToast(Constant.LiteralString.ToastMessage.addLike, duration: Constant.LiteralNumber.toastDuration)
            } else {
                view.makeToast(Constant.LiteralString.ToastMessage.removeLike, duration: Constant.LiteralNumber.toastDuration)
            }
        }

        viewModel.outputHideCollectionView.bind { [weak self] value in
            guard let value,
                  let self else { return }
            collectionView.isHidden = value
        }

        viewModel.outputDescriptionText.bind { [weak self] value in
            guard let value,
                  let self else { return }
            descriptionLabel.text = value
        }

        viewModel.outputErrorToast.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            view.makeToast(Constant.LiteralString.ErrorMessage.unstableStatus)
        }

        viewModel.outputScrollToTop.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPhotoList.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let photo = viewModel.outputPhotoList.value[indexPath.item]

        cell.addLike = { [weak self] in
            guard let self else { return }
            cell.isLike.toggle()
            viewModel.inputisLikeToggle.value = cell.isLike
        }
        cell.configureData(photo: photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.inputPrefetchCollectionView.value = indexPaths
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveNextVC(vc: DetailViewController(photo: viewModel.outputPhotoList.value[indexPath.item]))
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchButtonTapped.value = searchBar.text
    }
}
