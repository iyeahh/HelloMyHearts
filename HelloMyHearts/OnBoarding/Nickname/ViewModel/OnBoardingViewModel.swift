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
    }

    let imageList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    var state: State

    var inputNicknameTextField: Observable<String?> = Observable("")
    var inputCompleteButtonTapped: Observable<Void?> = Observable(nil)
    var inputImageSelected = Observable(0)
    var inputSaveButtonTapped: Observable<Void?> = Observable(nil)
    var inputSetImage: Observable<Void?> = Observable(nil)

    var outputDescription = Observable("")
    var outputImage = Observable(0)
    var outputNickname = Observable("")
    var outputValidCreate = Observable(true)
    var outputValidEdit = Observable(true)

    init(state: State) {
        self.state = state
        inputNicknameTextField.bind { [weak self] value in
            guard let value,
                  let self else { return }
            self.determineNickname()
            self.outputNickname.value = value
        }

        inputCompleteButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            self.completeButtonTapped()
        }

        inputImageSelected.bind { [weak self] value in
            guard let self else { return }
            UserDefaultsManager.shared.setValue(key: .tempImage, String(imageList[value]))
            outputImage.value = imageList[value]
        }

        inputSaveButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            self.saveButtonTapped()
        }

        inputSetImage.bind { [weak self] _ in
            guard let self else { return }
            self.setImage()
            if state == .edit {
                guard let nickname = UserDefaultsManager.shared.getValue(key: .nickname) else { return }
                self.outputNickname.value = nickname
            }
        }
    }

    private func saveButtonTapped() {
        guard isPossible()
                || outputNickname.value == UserDefaultsManager.shared.getValue(key: .nickname) else {
            outputValidEdit.value = false
            return
        }
        UserDefaultsManager.shared.createUserInfo(nickname: outputNickname.value, image: String(outputImage.value))
        outputValidEdit.value = true
    }

    private func completeButtonTapped() {
        guard isPossible() else {
            outputValidCreate.value = false
            return
        }
        UserDefaultsManager.shared.createUserInfo(nickname: outputNickname.value, image: String(outputImage.value))
        outputValidCreate.value = true
    }

    private func isPossible() -> Bool {
        guard inputNicknameTextField.value != nil else { return false }
        guard outputDescription.value == Constant.LiteralString.Nickname.possible else {
            return false
        }
        return true
    }

    private func validUserInput() throws -> Void {
        guard let text = inputNicknameTextField.value else {
            throw NicknameError.whiteSpace
        }

        guard !text.isEmpty && !text.contains(" ") else {
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
        } catch NicknameError.containNumber {
            outputDescription.value = Constant.LiteralString.Nickname.containNumber
        } catch NicknameError.containSymbol {
            outputDescription.value = Constant.LiteralString.Nickname.containSymbol
        } catch NicknameError.incorrectNumber {
            outputDescription.value = Constant.LiteralString.Nickname.incorrectNumber
        } catch NicknameError.whiteSpace {
            outputDescription.value = Constant.LiteralString.Nickname.whiteSpace
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
