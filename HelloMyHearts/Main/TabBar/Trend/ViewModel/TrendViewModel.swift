//
//  TrendViewModel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/29/24.
//

import Foundation

final class TrendViewModel {
    var imageList: [[Photo]] = [[], [], []]

    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var outputErrorToast: Observable<Void?> = Observable(nil)
    var outputReloadTableView: Observable<Void?> = Observable(nil)
    var outputImage: Observable<Int?> = Observable(nil)

    init() {
        transform()
    }

    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            callRequest()
        }
        
        inputViewWillAppear.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            if let image = UserDefaultsManager.shared.getValue(key: .image),
               let intImage = Int(image) {
                outputImage.value = intImage
            }
        }
    }

    private func callRequest() {
        let group = DispatchGroup()
        
        Topic.allCases.forEach { topic in
            group.enter()
            DispatchQueue.global().async(group: group) {
                APIService.shared.callRequest(api: .fetchTopicPhoto(topic: topic)) { [weak self] (response: Result<[Photo], NetworkError>) in
                    guard let self else { return }
                    switch response {
                    case .success(let success):
                        imageList[topic.rawValue] = success
                    case .failure(let failure):
                        switch failure {
                        case .unstableStatus:
                            outputErrorToast.value = ()
                        case .failedResponse:
                            print(Constant.LiteralString.ErrorMessage.failedResponse)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            outputReloadTableView.value = ()
        }
    }
}
