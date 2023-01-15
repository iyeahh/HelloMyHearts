//
//  DetailViewModel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/26/24.
//

import Foundation

final class DetailViewModel {
    var photo: Photo?
    var isLike = false

    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputLikeToggle: Observable<Void?> = Observable(nil)
    var outputLikeToggle: Observable<Bool?> = Observable(nil)
    var outputPhotoData: Observable<PhotoData?> = Observable(nil)
    var outputErrorToast: Observable<Void?> = Observable(nil)

    init() {
        transform()
    }

    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let self,
                  value != nil,
            let photo else { return }
            isLike = LikeTabelRepository.shared.checkIsLike(id: photo.id)

            fetchPhotoData { [weak self] photoData in
                guard let self else { return }
                outputPhotoData.value = photoData
            }
        }

        inputLikeToggle.bind { [weak self] value in
            guard value != nil,
                  let self,
                  let photo else { return }

            var isLikeValue: Bool

            if let outputLike = outputLikeToggle.value {
                isLikeValue = outputLike
            } else {
                isLikeValue = isLike
            }

            if isLikeValue {
                DocumentManager.shared.removeImageFromDocument(id: photo.id)
                LikeTabelRepository.shared.deleteLike(id: photo.id)
            } else {
                DocumentManager.shared.saveImageToDocument(urlString: photo.urls.small, id: photo.id)
                LikeTabelRepository.shared.createLike(photo: photo)
            }
            outputLikeToggle.value = !isLikeValue
        }
    }

    private func fetchPhotoData(completion: @escaping (PhotoData) -> Void) {
        guard let photo else { return }

        APIService.shared.callRequest(api: .fetchPhotoData(id: photo.id)) { [weak self] (response: Result<PhotoData, NetworkError>) in
            guard let self else { return }
            switch response {
            case .success(let success):
                completion(success)
            case .failure(let failure):
                switch failure {
                case .unstableStatus:
                    outputErrorToast.value = ()
                case .failedResponse:
                    print(Constant.LiteralString.ErrorMessage.failedResponse)
                }
            }
        }
    }
}
