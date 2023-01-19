//
//  SearchViewModel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/29/24.
//

import Foundation

final class SearchViewModel {
    private var searchPhoto = SearchPhoto()

    var photo: Photo?

    var inputSortButtonTapped: Observable<Void?> = Observable(nil)
    var inputisLikeToggle: Observable<Bool?> = Observable(nil)
    var inputPrefetchCollectionView: Observable<[IndexPath]?> = Observable(nil)
    var inputSearchButtonTapped: Observable<String?> = Observable(nil)
    var inputViewDidLoad: Observable<String?> = Observable(nil)
    var outputPhotoList: Observable<[Photo]> = Observable([])
    var outputSortButtonTitle: Observable<String?> = Observable(nil)
    var outputToastMessage: Observable<Bool?> = Observable(nil)
    var outputHideCollectionView: Observable<Bool?> = Observable(nil)
    var outputDescriptionText: Observable<String?> = Observable(nil)
    var outputErrorToast: Observable<Void?> = Observable(nil)
    var outputScrollToTop: Observable<Void?> = Observable(nil)

    init() {
        transform()
    }

    private func transform() {
        inputSortButtonTapped.bind { [weak self] value in
            guard value != nil,
            let self else { return }

            searchPhoto.sort.toggle()
            outputSortButtonTitle.value = searchPhoto.sortValue.title
            searchPhoto.page = 1
            callRequest()
        }

        inputisLikeToggle.bind { [weak self] value in
            guard let value,
                  let self,
            let photo else { return }

            if value {
                DocumentManager.shared.saveImageToDocument(urlString: photo.urls.small, id: photo.id)
                LikeTabelRepository.shared.createLike(photo: photo)
            } else {
                DocumentManager.shared.removeImageFromDocument(id: photo.id)
                LikeTabelRepository.shared.deleteLike(id: photo.id)
            }
            outputToastMessage.value = value
        }

        inputPrefetchCollectionView.bind { [weak self] indexPaths in
            guard let indexPaths,
                  let self else { return }

            for item in indexPaths {
                if outputPhotoList.value.count - 4 == item.row && !searchPhoto.isEnd {
                    searchPhoto.page += 1
                    callRequest()
                }
            }
        }

        inputSearchButtonTapped.bind { [weak self] value in
            guard let value,
            let self else { return }

            if !isEmptySearchBar(text: value) {
                searchPhoto.page = 1
                searchPhoto.searhWord = value
                callRequest()
            }
        }

        inputViewDidLoad.bind { [weak self] value in
            guard let value,
            let self else { return }
            let _ = isEmptySearchBar(text: value)
        }
    }

    private func callRequest() {
        APIService.shared.callRequest(api: .search(query: searchPhoto.searhWord, page: searchPhoto.page, sort: searchPhoto.sortValue)) { [weak self] (response: Result<ResultPhoto, NetworkError>) in
            guard let self else { return }

            switch response {
            case .success(let success):
                guard !success.results.isEmpty else {
                    outputHideCollectionView.value = true
                    outputDescriptionText.value = Constant.LiteralString.Search.EmptyDescription.result
                    return
                }

                outputHideCollectionView.value = false
                outputDescriptionText.value = ""

                if searchPhoto.page == 1 {
                    outputPhotoList.value = success.results
                    outputScrollToTop.value = ()
                } else {
                    outputPhotoList.value.append(contentsOf: success.results)
                }

                if searchPhoto.page == success.total_pages {
                    searchPhoto.isEnd = true
                }
                
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

    private func isOnlyWhitespace(text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func isEmptySearchBar(text: String) -> Bool {
        guard !isOnlyWhitespace(text: text) else {
            outputHideCollectionView.value = true
            outputDescriptionText.value = Constant.LiteralString.Search.EmptyDescription.word
            return true
        }
        return false
    }
}
