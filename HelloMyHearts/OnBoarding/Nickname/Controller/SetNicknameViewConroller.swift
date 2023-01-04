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

    var state: State

    var nickname: String? {
        didSet {
            nicknameTextField.text = nickname
        }
    }

    var profileImage = 0 {
        didSet {
            profileImageView.image = UIImage.getProfileImage(profileImage)
        }
    }

    var descriptionContent = "" {
        didSet {
            descriptionLabel.text = descriptionContent
        }
    }

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

    private let completeButton = {
        let button = AccentColorButton(title: Constant.LiteralString.Title.Button.complete)
        button.addTarget(nil, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    init(state: State) {
        viewModel = OnBoardingViewModel(state: state)
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        if state == .edit {
            completeButton.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputSetImage.value = ()
        viewModel.outputImage.bind { [weak self] image in
            guard let self else { return }
            profileImage = image
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        cameraBackImageView.layer.cornerRadius = cameraBackImageView.frame.width / 2
        cameraCircleImageView.layer.cornerRadius = cameraCircleImageView.frame.width / 2
    }

    override func configureNavi() {
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
        [naviBarView, profileImageView, setImageButton, cameraBackImageView, cameraCircleImageView, nicknameTextField, barView, descriptionLabel, completeButton].forEach { view.addSubview($0) }
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

        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
}

extension SetNicknameViewConroller {
    @objc private func setImageButtonTapped() {
        let setImageVC = SetImageViewController(viewModel: viewModel)
        moveNextVC(vc: setImageVC)
    }

    @objc private func textFieldDidChange(_ sender: UITextField) {
        viewModel.inputNicknameTextField.value = sender.text
    }

    @objc private func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = ()
        if viewModel.outputValidCreate.value {
            let rootView = TabBarViewController()
            moveNextVCWithWindow(needNavi: false, vc: rootView)
        }
    }
    @objc private func saveButtonTapped() {
        viewModel.inputSaveButtonTapped.value = ()
    }
}
