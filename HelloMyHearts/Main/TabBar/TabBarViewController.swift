//
//  TabBarViewController.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTabBar()
    }

    private func configureTabBar() {
        var viewControllers: [UIViewController] = []

        TabBar.allCases.forEach { tabBar in
            let vc = UINavigationController(rootViewController: tabBar.controller)
            vc.tabBarItem = UITabBarItem(title: "", image: tabBar.inactiveImage, selectedImage: tabBar.activeImage)
            viewControllers.append(vc)
        }

        setViewControllers(viewControllers, animated: true)
    }
}
