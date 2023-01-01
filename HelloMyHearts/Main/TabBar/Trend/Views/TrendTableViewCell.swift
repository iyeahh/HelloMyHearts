//
//  TrendTableViewCell.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit
import SnapKit

final class TrendTableViewCell: UITableViewCell {
    let titleLabel = {
        let label = UILabel()
        label.font = Constant.Font.bold21
        return label
    }()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 10) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.3)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return layout
    }

    private func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
