//
//  SaveViewModel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/29/24.
//

import Foundation

final class SaveViewModel {
    private var sort = true
    var likedPhoto: LikeTable?
    var photo: Photo?

    var inputSortButtonTapped: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputRemoveLike: Observable<Bool?> = Observable(nil)
    var inputDidSelectCell: Observable<Int?> = Observable(nil)
    var outputLikePhotoList: Observable<[LikeTable]> = Observable([])
    var outputSortButtonTitle: Observable<String?> = Observable(nil)
    var outputScrollToTop: Observable<Bool?> = Observable(nil)
    var outputToastMessage: Observable<Void?> = Observable(nil)

    init() {
        transform()
    }

    private func transform() {
        inputViewWillAppear.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            outputLikePhotoList.value = LikeTabelRepository.shared.readLike()
        }

        inputSortButtonTapped.bind { [weak self] value in
            guard value != nil,
                  let self else { return }
            
            sort.toggle()
            let sortValue: SortDate = sort ? .latest : .oldest
            
            outputLikePhotoList.value = LikeTabelRepository.shared.sortDate(standard: sortValue)
            outputSortButtonTitle.value = sortValue.title
            outputScrollToTop.value = true
        }

        inputRemoveLike.bind { [weak self] value in
            guard let value,
                  let self,
            let likedPhoto else { return }

            if value {
                DocumentManager.shared.removeImageFromDocument(id: likedPhoto.id)
                LikeTabelRepository.shared.deleteLike(id: likedPhoto.id)
                outputLikePhotoList.value = LikeTabelRepository.shared.readLike()
                outputToastMessage.value = ()
            }
        }

        inputDidSelectCell.bind { [weak self] value in
                guard let value,
                      let self else { return }

            let data = outputLikePhotoList.value[value]
            photo = Photo(id: data.id, created_at: data.createdDate, width: data.width, height: data.height, urls: URLImage(raw: data.url, small: ""), likes: data.likes, user: Photographer(name: data.photographerName, profile_image: Profile(medium: data.photographerProfileImage)))
        }
    }
}
