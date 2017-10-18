//
//  UILabelStyle.swift
//  EparkCure
//
//  Created by Yoshikuni Kato on 2017/05/10.
//  Copyright © 2017年 Ohako. Inc,. All rights reserved.
//

import UIKit

let darkSlateBlue: UIColor = UIColor(red: 16.0, green: 39.0, blue: 75.0, alpha: 1.0)

// swiftlint:disable type_body_length file_length
enum UILabelStyle {

    enum TitleInCellStyle {
        case normal
        case destructive
        case destructiveBlack
    }

    enum DetailFeatureStyle {
        case title
        case contents

        var lineSpacing: CGFloat {
            switch self {
            case .title:
                return  6.0
            case .contents:
                return 6.0
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .title:
                return 14.0
            case .contents:
                return 16.0
            }
        }

        var font: UIFont {
            switch self {
            case .title:
                return .boldRegularFont(ofSize: fontSize)
            case .contents:
                return .regularFont(ofSize: fontSize)

            }
        }
    }

    enum OpenHourIndexOfWeek: Int {
        case mon = 0
        case tue = 1
        case wed = 2
        case thu = 3
        case fri = 4
        case sat = 5
        case sun = 6
        case hol = 7
        var color: UIColor {
            switch self {
            case .sat:
                return UIColor(named: .softBlue)
            case .sun, .hol:
                return UIColor(named: .mediumPink)
            default:
                return  UIColor(named: .darkSlateBlue)

            }
        }
    }

    enum CommentStyle {
        case title
        case desc
        case userGenerationAndGender
        case date
    }

    enum PrimarySubjectColorStyle {
        case white
        case darkSlateBlue
        case rosyPink
        var color: UIColor {
            switch self {
            case .white:
                return .white
            case .darkSlateBlue:
                return UIColor(named: .darkSlateBlue)
            case .rosyPink:
                return UIColor(named: .rosyPink)
            }
        }
    }
    enum WhiteFontsStyle {
        case selectConditionButton
        case searchTopTitle
        var font: UIFont {
            switch self {
            case .selectConditionButton:
                return .boldRegularFont(ofSize: 12.0)
            case .searchTopTitle:
                return .boldRegularFont(ofSize: 16.0)
            }
        }
    }

    enum EparkColorStyle {
        case typeName
        case descriptionName
        var font: UIFont {
            switch self {
            case .typeName:
                return .boldRegularFont(ofSize: 24.0)
            case .descriptionName:
                return .regularFont(ofSize: 14.0)

            }
        }
    }

    enum DarkSlateBlueStyle {
//        case detailReserveSubtitle
//        case distanceDescription
        case boldTitleInCell
//        case normalTitleInCell
//        case clinicAndReservation
//        case mainTitleLabel
//        case titleInNavigation
//        case reservationNumberLabel
        var font: UIFont {
            switch self {
//            case .detailReserveSubtitle:
//                return .regularFont(ofSize: 12.0)
//            case .distanceDescription:
//                return .regularFont(ofSize: 13.0)
            case .boldTitleInCell:
                return .regularFont(ofSize: 14.0)
//            case .normalTitleInCell:
//                return .regularFont(ofSize: 16.0)
//            case .clinicAndReservation:
//                return .boldRegularFont(ofSize: 16.0)
//            case .mainTitleLabel:
//                return .regularFont(ofSize: 18.0)
//            case .titleInNavigation:
//                return .boldRegularFont(ofSize: 24)
//            case .reservationNumberLabel:
//                return .boldRegularFont(ofSize: 34.0)
            }

        }

    }

    // MARK: font size 10

//    case descriptionInCell
//
//    // MARK: font size 12
//    case slateFont12
//    case steelTwoNormal12
//    case primarySubjectName(style: PrimarySubjectColorStyle)
//    case buttonTitleWhite
//    case buttonTitlePink
//
//    case subTitleInNavigation
//    case selectConditionCount
//    // MARK: font size 13
//    case detailReserveTitle
//    case evaluationPoint
//
//    // MARK: font size 14
//    case slateFont14
//    case sectionName
//    case buttonTitlePink14
//    // MARK: font size 16
//
//    case detailfeatureCell(style: DetailFeatureStyle)
//
//    // MARK: font size 17
//    case titleInHeader

    // MARK: font size multi-value
    case darkSlateBlueFonts(style: DarkSlateBlueStyle)
//    case titleInCell(style: TitleInCellStyle)
//    case comment(style: CommentStyle)
//
//    case clinicColor(style: EparkColorStyle)
//    case pharmacyColor(style: EparkColorStyle)
//
//    case pinkFont14Bold
//    case openHour14(weekIndex: OpenHourIndexOfWeek, isbold: Bool)
//    case openHour16(weekIndex: OpenHourIndexOfWeek, isbold: Bool)
//    case whiteFonts(stlye: WhiteFontsStyle)

    // MARK: no font size(for attribute labels)
    case multipleLines

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func applyTo(label: UILabel) {
        switch self {
        // MARK: font size 11
//        case .descriptionInCell:
//            label.font = UIFont.regularFont(ofSize: 11.0)
//            label.textColor = UIColor(named: .blueyGrey)
//
//        // MARK: font size 12
//        case .slateFont12:
//            label.textColor = UIColor(named: .slate)
//            label.font = UIFont.regularFont(ofSize: 12.0)
//        case .steelTwoNormal12:
//            label.textColor = UIColor(named: .steelTwo)
//            label.font = .regularFont(ofSize: 12.0)
//        case .primarySubjectName(let style):
//            label.textColor = style.color
//            label.font = UIFont.boldRegularFont(ofSize: 12.0)
//        case .buttonTitleWhite:
//            label.textColor = UIColor.white
//            label.font = UIFont.boldRegularFont(ofSize: 12.0)
//        case .buttonTitlePink:
//            label.textColor = UIColor(named: .rosyPink)
//            label.font = UIFont.boldRegularFont(ofSize: 12.0)
//
//        case .subTitleInNavigation:
//            label.font = UIFont.regularFont(ofSize: 12.0)
//            label.textColor = UIColor(named: .steel)
//        case .selectConditionCount:
//            label.textColor = UIColor(named: .rosyPink)
//            label.backgroundColor = .white
//            label.layer.masksToBounds = true
//            label.layer.cornerRadius = 2.0
//            label.font = UIFont.regularFont(ofSize: 12.0)
//        // MARK: font size 13
//        case .detailReserveTitle:
//            label.textColor = UIColor(named: .darkSlateBlue)
//            label.font = UIFont.regularFont(ofSize: 13.0)
//            label.backgroundColor = UIColor(named: .paleGray)
//        case .evaluationPoint:
//            label.textColor = UIColor(named: .rosyPink)
//            label.font = .semiboldRegularFont(ofSize: 13.0)
//
//        // MARK: font size 14
//        case .slateFont14:
//            label.textColor = UIColor(named: .slate)
//            label.font = UIFont.regularFont(ofSize: 14.0)
//        case .sectionName:
//            label.font = UIFont.regularFont(ofSize: 14)
//            label.textColor = UIColor(named: .dusk)
//
//        case .buttonTitlePink14:
//            label.textColor = UIColor(named: .rosyPink)
//            label.font = UIFont.boldRegularFont(ofSize: 14.0)
//
//        // MARK: font size 16
//
//        case .detailfeatureCell(let style):
//            label.baselineAdjustment = .alignCenters
//            label.font = style.font
//            label.textColor = UIColor(named: .darkSlateBlue)
//            label.sizeToFit()
//
//        // MARK: font size 17
//        case .titleInHeader:
//            label.font = UIFont.boldRegularFont(ofSize: 17.0)
//            label.textColor = .white

        // MARK: font size multi-value
        case .darkSlateBlueFonts(let style):
            label.textColor = darkSlateBlue
            label.font = style.font
//        case .titleInCell(let style):
//            label.font = UIFont.regularFont(ofSize: 16)
//            switch style {
//            case .normal:
//                label.textColor = UIColor(named: .darkSlateBlue)
//                label.textAlignment = .left
//            case .destructive:
//                label.textColor = UIColor(named: .scarlet)
//                label.textAlignment = .center
//            case .destructiveBlack:
//                label.textColor = .black
//                label.textAlignment = .center
//            }
//        case .comment(let style):
//            label.font = UIFont.regularFont(ofSize: 16)
//            switch style {
//            case .title:
//                label.textColor = UIColor(named: .darkSlateBlue)
//                label.textAlignment = .left
//                label.font = UIFont.boldRegularFont(ofSize: 16)
//            case .desc:
//                label.textColor = UIColor(named: .darkSlateBlue)
//                label.textAlignment = .left
//                label.font = UIFont.regularFont(ofSize: 14)
//            case .userGenerationAndGender:
//                label.textColor = UIColor(named: .slate)
//                label.textAlignment = .right
//                label.font = UIFont.regularFont(ofSize: 14)
//            case .date:
//                label.textColor = UIColor(named: .slate)
//                label.textAlignment = .right
//                label.font = UIFont.regularFont(ofSize: 12)
//
//            }
//
//        case .clinicColor(let style):
//            label.textColor = UIColor(named: .rosyPink)
//            label.font = style.font
//        case .pharmacyColor(let style):
//            label.textColor = UIColor(named: .darkSkyBlue)
//            label.font = style.font
//
//        case .pinkFont14Bold:
//            label.textColor = UIColor(named: .rosyPink)
//            label.font = UIFont.boldRegularFont(ofSize: 14.0)
//        case .openHour14(let weekIndex, let isbold):
//            if isbold {
//                label.font = UIFont.boldRegularFont(ofSize: 14.0)
//            } else {
//                label.font = UIFont.regularFont(ofSize: 14.0)
//            }
//            label.textColor = weekIndex.color
//        case .openHour16(let weekIndex, let isbold):
//            if isbold {
//                label.font = UIFont.boldRegularFont(ofSize: 16.0)
//            } else {
//                label.font = UIFont.regularFont(ofSize: 16.0)
//            }
//            label.textColor = weekIndex.color
//
//        case .whiteFonts(let stlye):
//            label.textColor = UIColor.white
//            label.font = stlye.font
//
//        // MARK: no font size(for attribute labels)
//        case .multipleLines:
//            label.lineBreakMode = .byWordWrapping
//            label.numberOfLines = 0

        }

    }

}

extension UILabel {
    func apply(style: UILabelStyle) {
        style.applyTo(label: self)
    }
}
