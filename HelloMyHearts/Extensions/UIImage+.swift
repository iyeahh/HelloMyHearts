//
//  UIImage+.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import UIKit

extension UIImage {
    static func getProfileImage(_ num: Int) -> UIImage? {
        return UIImage(named: "profile_\(num)")
    }
}
