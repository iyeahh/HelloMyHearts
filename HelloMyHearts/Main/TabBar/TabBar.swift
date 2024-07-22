//
//  TabBar.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

enum TabBar: String, CaseIterable {
    case trend = "OUR TOPIC"
    case randomImage
    case search = "SEARCH PHOTO"
    case save = "MY HEARTS"

    var activeImage: UIImage? {
        switch self {
        case .trend:
            return UIImage(named: "tab_trend")?.withRenderingMode(.alwaysOriginal)
        case .randomImage:
            return UIImage(named: "tab_random")?.withRenderingMode(.alwaysOriginal)
        case .search:
            return UIImage(named: "tab_search")?.withRenderingMode(.alwaysOriginal)
        case .save:
            return UIImage(named: "tab_like")?.withRenderingMode(.alwaysOriginal)
        }
    }

    var inactiveImage: UIImage? {
        switch self {
        case .trend:
            return UIImage(named: "tap_trend_inactive")
        case .randomImage:
            return UIImage(named: "tab_random_inactive")
        case .search:
            return UIImage(named: "tab_search_inactive")
        case .save:
            return UIImage(named: "tab_like_inactive")
        }
    }

    var controller: UIViewController {
        switch self {
        case .trend:
            return TrendViewController()
        case .randomImage:
            return RandomImageViewController()
        case .search:
            return SearchViewController()
        case .save:
            return SaveViewController()
        }
    }
}
