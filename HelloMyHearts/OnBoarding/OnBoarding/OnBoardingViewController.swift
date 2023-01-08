//
//  OnBoardingViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit
import SnapKit

final class OnBoardingViewController: BaseViewController {
    private let serviceTitleLabel = {
        let label = UILabel()
        label.font = Constant.Font.title
        label.text = Constant.LiteralString.Title.service
        label.numberOfLines = 2
        label.textColor = Constant.Color.accent
        return label
    }()

    private let mainImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constant.Image.launch
        return imageView
    }()

    private let nameLabel = {
        let label = UILabel()
        label.text = "양보라"
        label.font = Constant.Font.name
        label.textAlignment = .center
        return label
    }()

    private let startButton = {
        let button = AccentColorButton(title: Constant.LiteralString.Title.Button.start)
        button.addTarget(nil, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    override func configureHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(serviceTitleLabel)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
    }

    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(mainImageView.snp.width)
            make.centerY.equalToSuperview()
        }

        serviceTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalTo(mainImageView.snp.top).offset(-20)
        }

        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
        }

        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }

    @objc private func startButtonTapped() {
        let setNicknameVC = SetNicknameViewConroller(state: .create)
        moveNextVC(vc: setNicknameVC)
    }
}
