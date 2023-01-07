//
//  SetNicknameViewConroller.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit
import SnapKit

final class SetNicknameViewConroller: BaseViewController {
    let viewModel: OnBoardingViewModel

    private let naviBarView = BarView()

    private let profileImageView = ProfileImageView()

    private let setImageButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(nil, action: #selector(setImageButtonTapped), for: .touchUpInside)
        return button
    }()

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

    private let nicknameTextField = {
        let textField = UITextField()
        textField.placeholder = Constant.LiteralString.Nickname.placeholer
        textField.borderStyle = .none
        textField.font = Constant.Font.system14
        return textField
    }()

    private let barView = BarView()

    private let descriptionLabel = {
        let label = UILabel()
        label.textColor = Constant.Color.accent
        label.text = Constant.LiteralString.Nickname.incorrectNumber
        label.font = Constant.Font.system13
        return label
    }()

    private let mbtiLabel = Bold15FontLabel(title: MBTI.mbti)

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())

    private let completeButton = {
        let button = AccentColorButton(title: Constant.LiteralString.Title.Button.complete)
        button.addTarget(nil, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let cancelMembershipButton = {
        let button = UIButton()
        button.setTitle(Constant.LiteralString.Title.Button.cancelMembership, for: .normal)
        button.setTitleColor(Constant.Color.accent, for: .normal)
        button.titleLabel?.font = Constant.Font.bold13
        button.setUnderline()
        button.addTarget(nil, action: #selector(cancelMembershipButtonTapped), for: .touchUpInside)
        return button
    }()

    init(state: State) {
        viewModel = OnBoardingViewModel(state: state)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        if viewModel.state == .edit {
            completeButton.isHidden = true
        } else {
            cancelMembershipButton.isHidden = true
        }

        bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppear.value = ()
        viewModel.outputImage.bind { [weak self] value in
            guard let self else { return }
            profileImageView.image = UIImage.getProfileImage(value)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        cameraBackImageView.layer.cornerRadius = cameraBackImageView.frame.width / 2
        cameraCircleImageView.layer.cornerRadius = cameraCircleImageView.frame.width / 2
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width * 0.5) / 4
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }

    override func configureNavi() {
        navigationController?.navigationBar.isHidden = false

        if viewModel.state == .create {
            navigationItem.title = State.create.rawValue
            UserDefaultsManager.shared.remove(.tempImage)
        } else {
            navigationItem.title = State.edit.rawValue

            let barButtonItem = UIBarButtonItem(title: Constant.LiteralString.Title.Button.save, style: .plain, target: self, action: #selector(saveButtonTapped))
            barButtonItem.tintColor = Constant.Color.secondary
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    override func configureHierarchy() {
        [naviBarView, profileImageView, setImageButton, cameraBackImageView, cameraCircleImageView, nicknameTextField, barView, descriptionLabel, mbtiLabel, collectionView, completeButton, cancelMembershipButton].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        naviBarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(profileImageView.snp.width)
        }

        setImageButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
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

        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
        }

        barView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.height.equalTo(1)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(barView.snp.bottom).offset(10)
        }

        mbtiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
        }

        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }

        collectionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(80)
            make.bottom.equalTo(completeButton.snp.top)
        }

        cancelMembershipButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalToSuperview()
        }
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SetMbtiCollectionViewCell.self, forCellWithReuseIdentifier: SetMbtiCollectionViewCell.identifier)
    }
}

extension SetNicknameViewConroller {
    private func bindData() {
        viewModel.outputMbti.bind { [weak self] _ in
            guard let self else { return }
            collectionView.reloadData()
        }

        viewModel.outputNickname.bind { [weak self] value in
            guard let self else { return }
            nicknameTextField.text = value
        }

        viewModel.outputDescription.bind { [weak self] value in
            guard let self else { return }
            descriptionLabel.text = value
        }

        viewModel.outputConfirmButtonStatus.bind { [weak self] value in
            guard let self else { return }

            completeButton.backgroundColor = value ? Constant.Color.accent : Constant.Color.secondaryGray
            navigationItem.rightBarButtonItem?.tintColor = value ? Constant.Color.accent : Constant.Color.secondaryGray
            completeButton.isEnabled = value
            navigationItem.rightBarButtonItem?.isEnabled = value
        }

        viewModel.outputLabelColor.bind { [weak self] value in
            guard let self else { return }

            descriptionLabel.textColor = value ? Constant.Color.accent : Constant.Color.warning
        }

        viewModel.outputValidEdit.bind { [weak self] value in
            guard let self else { return }
            if value {
                navigationController?.popViewController(animated: true)
            }
        }

        viewModel.outputValidCreate.bind { [weak self] value in
            guard let self else { return }
            if value {
                let rootView = TabBarViewController()
                moveNextVCWithWindow(needNavi: false, vc: rootView)
            }
        }

        viewModel.outputExistTabbar.bind { [weak self] value in
            guard let self else { return }
            tabBarController?.tabBar.isHidden = !value
        }
    }

    @objc private func setImageButtonTapped() {
        let setImageVC = SetImageViewController(viewModel: viewModel)
        moveNextVC(vc: setImageVC)
    }

    @objc private func textFieldDidChange(_ sender: UITextField) {
        viewModel.inputNicknameTextField.value = sender.text
    }

    @objc private func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = ()
    }

    @objc private func saveButtonTapped() {
        viewModel.inputSaveButtonTapped.value = ()
    }

    @objc private func cancelMembershipButtonTapped() {
        let alert = makeAlert(confirmButtonTapped: confirmButtonTapped)
        present(alert, animated: true)
    }

    private func confirmButtonTapped() {
        viewModel.inputConfirmButtonTapped.value = ()

        let onBoardingVC = OnBoardingViewController()
        moveNextVCWithWindow(needNavi: true, vc: onBoardingVC)
    }
}

extension SetNicknameViewConroller: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MBTI.mbtiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetMbtiCollectionViewCell.identifier, for: indexPath) as? SetMbtiCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = MBTI.mbtiList[indexPath.item]

        if indexPath.item > 3 {
            let index = indexPath.item - 4
            if let value = viewModel.outputMbti.value[index] {
                if !value {
                    cell.configureData(title: title, type: .isSelected)
                } else {
                    cell.configureData(title: title, type: .unSelected)
                }
            } else {
                cell.configureData(title: title, type: .unSelected)
            }
        } else {
            if let value = viewModel.outputMbti.value[indexPath.item] {
                if value {
                    cell.configureData(title: title, type: .isSelected)
                } else {
                    cell.configureData(title: title, type: .unSelected)
                }
            } else {
                cell.configureData(title: title, type: .unSelected)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 3 {
            let index = indexPath.item - 4
            viewModel.outputMbti.value[index] = false
        } else {
            viewModel.outputMbti.value[indexPath.item] = true
        }
        viewModel.inputDidSelectCell.value = ()
        collectionView.reloadData()
    }
}
