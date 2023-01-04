//
//  UIViewController+.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/25/24.
//

import UIKit

extension UIViewController {
    func moveNextVC(vc: UIViewController) {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(vc, animated: true)
    }

    func moveNextVCWithWindow(needNavi: Bool, vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        if needNavi {
            let rootVC = UINavigationController(rootViewController: vc)
            sceneDelegate?.window?.rootViewController = rootVC
        } else {
            sceneDelegate?.window?.rootViewController = vc
        }
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
