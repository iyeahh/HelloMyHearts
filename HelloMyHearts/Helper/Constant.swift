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
        static let accent = UIColor(hex: 0x186FF2)
        static let warning = UIColor(hex: 0xF04452)
        static let secondaryDarkGray = UIColor(hex: 0x4D5652)
        static let secondaryGray = UIColor(hex: 0x8C8C8C)
        static let secondaryLightGray = UIColor(hex: 0xF2F2F2)
        static let star = UIColor.systemYellow
    }

    enum Font {
        static let system10: UIFont = .systemFont(ofSize: 10)
        static let system13: UIFont = .systemFont(ofSize: 13)
        static let bold11: UIFont = .boldSystemFont(ofSize: 11)
        static let bold15: UIFont = .boldSystemFont(ofSize: 15)
        static let bold17: UIFont = .boldSystemFont(ofSize: 17)
        static let bold19: UIFont = .boldSystemFont(ofSize: 19)
        static let bold32: UIFont = .boldSystemFont(ofSize: 32)
    }

    enum Charactor {
        case isSelected
        case unSelected

        var borderSetting: (borderWidth: CGFloat, alpha: CGFloat) {
            switch self {
            case .isSelected:
                return (3, 1)
            case .unSelected:
                return (1, 0.5)
            }
        }
    }

    enum API {
        enum param {
            static let query = "query"
            static let page = "page"
            static let perPage = "per_page"
            static let perPageValue = 20
            static let sort = "order_by"
            static let key = "client_id"
        }
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
            static let service = "Hello, My Hearts"

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

        enum MBTI {
            static let mbti = "MBTI"
            static let e = "E"
            static let i = "I"
            static let s = "S"
            static let n = "N"
            static let t = "T"
            static let f = "F"
            static let j = "J"
            static let p = "P"
        }

        enum Topic {
            static let goldenHour = "골든 아워"
            static let business = "비즈니스 및 업무"
            static let interior = "건축 및 인테리어"
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
    }

    enum LiteralNumber {
        static let cornerRadius: CGFloat = 12
        static let toastDuration = 1.0
    }
}
