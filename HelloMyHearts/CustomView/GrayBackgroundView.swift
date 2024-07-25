//
//  GrayBackgroundView.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit
import SnapKit

class GrayBackgroundView: UIView {
    private let grayView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.secondaryDarkGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constant.LiteralNumber.cornerRadius
        return view
    }()

    private let starImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.Icon.star
        imageView.tintColor = Constant.Color.star
        return imageView
    }()

    let numberLabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primary
        label.font = Constant.Font.system10
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GrayBackgroundView {
    private func configureHierarchy() {
        addSubview(grayView)
        addSubview(numberLabel)
        addSubview(starImageView)
    }

    private func configureLayout() {
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalTo(starImageView.snp.height)
            make.centerY.equalToSuperview()
        }

        numberLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(5)
            make.verticalEdges.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { make in
            make.verticalEdges.edges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(numberLabel.snp.trailing).offset(10)
        }
    }
}
