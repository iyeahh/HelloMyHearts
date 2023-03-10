//
//  Constant.swift
//  HelloMyHearts
//
//  Created by Bora Yang on 7/22/24.
//

import UIKit

enum Constant {
    enum Color {
        static let primary = UIColor(hex: 0xFFFFFF)
        static let secondary = UIColor(hex: 0x000000)
        static let accent = UIColor.systemGreen
        static let warning = UIColor(hex: 0xF04452)
        static let secondaryDarkGray = UIColor(hex: 0x4D5652)
        static let secondaryGray = UIColor(hex: 0x8C8C8C)
        static let secondaryLightGray = UIColor(hex: 0xF2F2F2)
        static let star = UIColor.systemYellow
    }

    enum Font {
        static let system10: UIFont = .systemFont(ofSize: 10)
        static let system13: UIFont = .systemFont(ofSize: 13)
        static let system14: UIFont = .systemFont(ofSize: 14)
        static let bold11: UIFont = .boldSystemFont(ofSize: 11)
        static let bold13: UIFont = .boldSystemFont(ofSize: 13)
        static let bold15: UIFont = .boldSystemFont(ofSize: 15)
        static let bold17: UIFont = .boldSystemFont(ofSize: 17)
        static let bold19: UIFont = .boldSystemFont(ofSize: 19)
        static let name: UIFont = .systemFont(ofSize: 25, weight: .heavy)
        static let bold32: UIFont = .boldSystemFont(ofSize: 32)
        static let title: UIFont? = UIFont(name: "Rockwell-Bold", size: 35)
    }

    enum Image {
        static let launch = UIImage(named: "launchImage")

        enum Icon {
            enum Like {
                static let like = UIImage(named: "like")
                static let likeInactive = UIImage(named: "like_inactive")
                static let circleLike = UIImage(named: "like_circle")
                static let circleLikeInactive = UIImage(named: "like_circle_inactive")
            }

            static let camera = UIImage(systemName: "camera.fill")
            static let star = UIImage(systemName: "star.fill")
        }
    }

    enum LiteralString {
        enum Title {
            static let service = "HELLO        MY HEARTS 💙"
            static let name = "양보라"

            enum Button {
                static let start = "시작하기"
                static let complete = "완료"
                static let save = "저장"
                static let cancelMembership = "회원탈퇴"
            }
        }

        enum ToastMessage {
            static let addLike = "좋아요가 추가되었어요"
            static let removeLike = "좋아요가 제거되었어요"
        }

        enum Nickname {
            static let placeholer = "닉네임을 입력해주세요 :)"
            static let possible = "사용할 수 있는 닉네임이에요."
            static let incorrectNumber = "2글자 이상 10글자 미만으로 설정해주세요."
            static let containNumber = "닉네임에 숫자는 포함할 수 없어요."
            static let whiteSpace = "닉네임에 공백은 포함할 수 없어요."
            static let containSymbol = "닉네임에 @, #, $, %는 포함할 수 없어요."

            enum ContainWrongCharactor: String, CaseIterable {
                case at = "@"
                case sharp = "#"
                case dollar = "$"
                case percent = "%"
            }
        }

        enum Search {
            static let placeholder = "키워드 검색"

            enum EmptyDescription {
                static let word = "사진을 검색해보세요"
                static let result = "검색 결과가 없어요"
                static let save = "저장한 사진이 없어요"
            }
        }

        enum Detail {
            static let information = "정보"
            static let size = "크기"
            static let views = "조회수"
            static let downloads = "다운로드"
        }

        enum ErrorMessage {
            static let unstableStatus = "네트워크 상태를 확인 후 다시 시도해 주세요"
            static let failedResponse = "응답값 확인"
        }

        enum Alert {
            static let message = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?"

            enum Title: String {
                case alert = "탈퇴하기"
                case confirm = "확인"
                case cancel = "취소"
            }
        }
    }

    enum LiteralNumber {
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius20: CGFloat = 20
        static let toastDuration = 1.0
        static let border: CGFloat = 5
    }
}
