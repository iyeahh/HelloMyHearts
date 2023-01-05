//
//  SetImageViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit

final class SetImageViewController: BaseViewController {
    var viewModel: OnBoardingViewModel

    private let barView = BarView()

    private let profileImageView = ProfileImageView()

    private let cameraBackImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constant.Color.accent
        return imageView
    }()

    private let cameraCircleImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.Icon.camera
        imageView.tintColor = Constant.Color.primary
        imageView.backgroundColor = Constant.Color.accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())

    init(viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        cameraBackImageView.layer.cornerRadius = cameraBackImageView.frame.width / 2
        cameraCircleImageView.layer.cornerRadius = cameraCircleImageView.frame.width / 2
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width - 50) / 4
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }

    override func configureNavi() {
        navigationItem.title = viewModel.state.rawValue
    }

    override func configureHierarchy() {
        view.addSubview(barView)
        view.addSubview(profileImageView)
        view.addSubview(cameraBackImageView)
        view.addSubview(cameraCircleImageView)
        view.addSubview(imageCollectionView)
    }

    override func configureLayout() {
        barView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(profileImageView.snp.width)
        }

        cameraBackImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.width.equalTo(profileImageView).multipliedBy(0.25)
            make.height.equalTo(cameraBackImageView.snp.width)
        }

        cameraCircleImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(cameraBackImageView)
            make.width.equalTo(cameraBackImageView).multipliedBy(0.7)
            make.height.equalTo(cameraCircleImageView.snp.width)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(cameraBackImageView.snp.bottom).offset(30)
        }
    }

    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

        imageCollectionView.register(SetImageCollectionViewCell.self, forCellWithReuseIdentifier: SetImageCollectionViewCell.identifier)
    }

    private func bindData() {
        viewModel.outputImage.bind { [weak self] value in
            guard let self else { return }
            profileImageView.image = UIImage.getProfileImage(value)
            imageCollectionView.reloadData()
        }
    }
}

extension SetImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetImageCollectionViewCell.identifier, for: indexPath) as? SetImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.imageList[indexPath.item]
        if image == viewModel.outputImage.value {
            cell.configureImage(image, type: .isSelected)
        } else {
            cell.configureImage(image, type: .unSelected)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputImageSelected.value = viewModel.imageList[indexPath.item]
    }
}
