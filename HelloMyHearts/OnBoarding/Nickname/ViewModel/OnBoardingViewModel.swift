//
//  OnBoardingViewModel.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/27/24.
//

import Foundation

final class OnBoardingViewModel {
    private enum NicknameError: Error {
        case incorrectNumber
        case containNumber
        case whiteSpace
        case containSymbol
        case empty
    }

    let imageList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    var state: State

    var inputNicknameTextField: Observable<String?> = Observable("")
    var inputCompleteButtonTapped: Observable<Void?> = Observable(nil)
    var inputImageSelected = Observable(0)
    var inputSaveButtonTapped: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputDidSelectCell: Observable<Void?> = Observable(nil)
    var inputConfirmButtonTapped: Observable<Void?> = Observable(nil)

    var outputDescription = Observable("")
    var outputLabelColor =  Observable(false)
    var outputImage = Observable(0)
    var outputNickname = Observable("")
    var outputValidCreate = Observable(true)
    var outputValidEdit = Observable(true)
    var outputMbti: Observable<[Bool?]> = Observable([nil, nil, nil, nil])
    var outputConfirmButtonStatus = Observable(false)
    var outputExistTabbar = Observable(true)

    init(state: State) {
        self.state = state
        transform()
    }

    private func transform() {
        inputNicknameTextField.bind { [weak self] value in
            guard let value,
                  let self else { return }
            determineNickname()
            outputNickname.value = value
            outputConfirmButtonStatus.value = isPossible()
        }

        inputCompleteButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            completeButtonTapped()
        }

        inputImageSelected.bind { [weak self] value in
            guard let self else { return }
            UserDefaultsManager.shared.setValue(key: .tempImage, String(imageList[value]))
            outputImage.value = imageList[value]
        }

        inputSaveButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            saveButtonTapped()
        }

        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            setImage()
            if state == .edit {
                guard let nickname = UserDefaultsManager.shared.getValue(key: .nickname),
                      let mbti = UserDefaultsManager.shared.mbti else { return }
                outputNickname.value = nickname
                inputNicknameTextField.value = nickname
                outputMbti.value = mbti
                outputExistTabbar.value = false
            }
        }

        inputDidSelectCell.bind { [weak self] value in
            guard let self,
                  value != nil else { return }
            outputConfirmButtonStatus.value = isPossible()
        }

        inputConfirmButtonTapped.bind { value in
            guard value != nil else { return }
            UserDefaultsManager.shared.removeAll()
        }
    }

    private func saveButtonTapped() {
        guard isPossible()
                || outputNickname.value == UserDefaultsManager.shared.getValue(key: .nickname) else {
            outputValidEdit.value = false
            return
        }
        UserDefaultsManager.shared.createUserInfo(nickname: outputNickname.value, image: String(outputImage.value), inputMbti: outputMbti.value)
        outputValidEdit.value = true
    }

    private func completeButtonTapped() {
        guard isPossible() else {
            outputValidCreate.value = false
            return
        }
        UserDefaultsManager.shared.createUserInfo(nickname: outputNickname.value, image: String(outputImage.value), inputMbti: outputMbti.value)
        outputValidCreate.value = true
    }

    private func isPossible() -> Bool {
        guard inputNicknameTextField.value != nil,
              outputDescription.value == Constant.LiteralString.Nickname.possible,
              outputMbti.value.compactMap({ $0 }).count == 4 else { return false }
        return true
    }

    private func validUserInput() throws -> Void {
        guard let text = inputNicknameTextField.value,
              !text.isEmpty else {
            throw NicknameError.empty
        }

        guard !text.contains(" ") else {
            throw NicknameError.whiteSpace
        }

        try Constant.LiteralString.Nickname.ContainWrongCharactor.allCases.forEach { character in
            guard !text.contains(character.rawValue) else {
                throw NicknameError.containSymbol
            }
        }

        let numArray = text.filter { character in
            character.isNumber
        }

        guard numArray.isEmpty else {
            throw NicknameError.containNumber
        }

        guard text.count > 1 && text.count < 10 else {
            throw NicknameError.incorrectNumber
        }
    }

    private func determineNickname() {
        do {
            try validUserInput()
            outputDescription.value = Constant.LiteralString.Nickname.possible
            outputLabelColor.value = true
        } catch NicknameError.empty {
            outputDescription.value = ""
        } catch NicknameError.containNumber {
            outputDescription.value = Constant.LiteralString.Nickname.containNumber
            outputLabelColor.value = false
        } catch NicknameError.containSymbol {
            outputDescription.value = Constant.LiteralString.Nickname.containSymbol
            outputLabelColor.value = false
        } catch NicknameError.incorrectNumber {
            outputDescription.value = Constant.LiteralString.Nickname.incorrectNumber
            outputLabelColor.value = false
        } catch NicknameError.whiteSpace {
            outputDescription.value = Constant.LiteralString.Nickname.whiteSpace
            outputLabelColor.value = false
        } catch {
            outputDescription.value = "닉네임 양식에 맞지 않음"
        }
    }

    func randomImage() {
        guard let num = imageList.randomElement() else {
            outputImage.value = 0
            return
        }
        outputImage.value = num
    }

    func setImage() {
        guard state == .edit else {
            guard let tempImage = UserDefaultsManager.shared.getValue(key: .tempImage),
            let image = Int(tempImage) else {
                randomImage()
                return
            }
            UserDefaultsManager.shared.remove(.tempImage)

            outputImage.value = image
            return
        }
        guard let tempImage = UserDefaultsManager.shared.getValue(key: .tempImage),
        let intTempImage = Int(tempImage) else {
            guard let savedImage = UserDefaultsManager.shared.getValue(key: .image),
            let intImage = Int(savedImage) else {
                outputImage.value = 0
                return
            }
            outputImage.value = intImage
            return
        }
        UserDefaultsManager.shared.remove(.tempImage)
        outputImage.value = intTempImage
        return
    }

    deinit {
        print("OnBoardingViewModel deinit")
    }
}
