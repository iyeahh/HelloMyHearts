//
//  UIViewController+.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/25/24.
//

import UIKit

extension UIViewController {
    func urlToImage(urlString: String) -> UIImage? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("URL을 UIImage로 변환 실패")
            return nil
        }
    }

    func saveImageToDocument(urlString: String, id: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first,
              let image = urlToImage(urlString: urlString) else { return }

        let fileURL = documentDirectory.appendingPathComponent("\(id).jpg")

        guard let data = image.jpegData(compressionQuality: 0.5) else { return }

        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }

    func loadImageToDocument(id: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }

        let fileURL = documentDirectory.appendingPathComponent("\(id).jpg")

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }

    func removeImageFromDocument(id: String) {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            let fileURL = documentDirectory.appendingPathComponent("\(id).jpg")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print("file remove error", error)
                }

            } else {
                print("file no exist")
            }
        }
}
