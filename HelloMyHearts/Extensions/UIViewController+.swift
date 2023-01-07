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

    func makeAlert(confirmButtonTapped: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(
            title: Constant.LiteralString.Alert.Title.alert.rawValue,
            message: Constant.LiteralString.Alert.message,
            preferredStyle: .alert)

        let confirm = UIAlertAction(
            title: Constant.LiteralString.Alert.Title.confirm.rawValue,
            style: .default,
            handler: { _ in
                confirmButtonTapped?()
            })

        let cancel = UIAlertAction(
            title: Constant.LiteralString.Alert.Title.cancel.rawValue,
            style: .cancel,
            handler: nil)

        alert.addAction(cancel)
        alert.addAction(confirm)

        return alert
    }
}
