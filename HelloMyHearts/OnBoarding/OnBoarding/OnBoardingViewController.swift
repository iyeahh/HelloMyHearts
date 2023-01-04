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
        label.font = Constant.Font.bold32
        label.textAlignment = .center
        label.text = Constant.LiteralString.Title.service
        label.textColor = Constant.Color.accent
        return label
    }()

    private let mainImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constant.Image.launch
        return imageView
    }()

    private let startButton = {
        let button = AccentColorButton(title: Constant.LiteralString.Title.Button.start)
        button.addTarget(nil, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    override func configureHierarchy() {
        view.addSubview(serviceTitleLabel)
        view.addSubview(mainImageView)
        view.addSubview(startButton)
    }

    override func configureLayout() {
        serviceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.horizontalEdges.equalToSuperview().inset(30)
        }

        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        mainImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(mainImageView.snp.height)
        }
    }

    @objc private func startButtonTapped() {
        let setNicknameVC = SetNicknameViewConroller(state: .edit)
        moveNextVC(vc: setNicknameVC)
    }
}
