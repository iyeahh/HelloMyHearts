//
//  BaseViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = Constant.Color.primary
        configureNavi()
        configureHierarchy()
        configureLayout()
    }

    func configureNavi() {}
    func configureHierarchy() {}
    func configureLayout() {}
}

