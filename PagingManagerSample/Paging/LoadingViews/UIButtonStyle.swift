//
//  UIButtonStyle.swift
//  EparkCure
//
//  Created by Yoshikuni Kato on 2017/05/15.
//  Copyright © 2017年 Ohako, Inc. All rights reserved.
//

import UIKit

enum UIButtonStyle {
    case destructive
    case black
    case roundedAndPink(type: RoundedAndPinkType)
    case searchConditionToggle
    case transparent
    case whiteTintColor
    case darkSlateBlueTintColor
    case rosyPinkTintColor
    case buttonInHeader
    case themeColorToggle
    case telreserveOpenurl
    case showMap
    case retryButton
    case withoutLogin

    // swiftlint:disable cyclomatic_complexity
    //swiftlint:disable:next function_body_length

    enum RoundedAndPinkType {
        case clinicView
        case reservation
        case telephone
        case telephoneAtBottom

        var cornerRadius: CGFloat {
            switch self {
            case .clinicView:
                return 22.0
            case .reservation, .telephoneAtBottom:
                return 28.0
            case .telephone:
                return 24.0
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .clinicView, .telephone:
                return 14.0
            case .reservation, .telephoneAtBottom:
                return 16.0
            }
        }

        var titleColor: UIColor {
            switch self {
            case .clinicView, .reservation:
                return .white
            case .telephone, .telephoneAtBottom:
                return UIColor(named: .rosyPink)
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .clinicView, .reservation:
                return UIColor(named: .rosyPink)
            case .telephone, .telephoneAtBottom:
                return UIColor(named: .veryLightPurple)
            }
        }

        var tintColor: UIColor {
            switch self {
            case .clinicView, .reservation:
                return .white
            case .telephone, .telephoneAtBottom:
                return UIColor(named: .rosyPink)
            }
        }
    }
    //swiftlint:disable:next function_body_length
    func apply(to button: UIButton) {
        switch self {
        case .destructive:
            button.setTitleColor(UIColor(named: .scarlet), for: .normal)
            button.titleLabel?.font = UIFont.regularFont(ofSize: 16.0)
        case .black:
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.regularFont(ofSize: 16.0)
        case .roundedAndPink(let type):
            button.setTitleColor(type.titleColor, for: .normal)
            button.titleLabel?.font = UIFont.boldRegularFont(ofSize: type.fontSize)
            button.backgroundColor = type.backgroundColor
            button.tintColor = type.tintColor
            button.layer.cornerRadius = type.cornerRadius
            button.layer.shadowRadius = 4.0
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 0.54
            button.layer.shadowColor = UIColor(named: .rosyPink).cgColor
            button.layer.shouldRasterize = true
            button.layer.rasterizationScale = UIScreen.main.scale
        case .searchConditionToggle:
            button.titleLabel?.font = UIFont.boldRegularFont(ofSize: 12.0)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(UIColor(named: .rosyPink), for: .selected)
            button.setBackgroundImage(UIImage.makeImage(of: .white), for: .selected)
            button.tintColor = .clear
        case .transparent:
            button.layer.backgroundColor = UIColor.clear.cgColor
        case .whiteTintColor:
            button.tintColor = .white
        case .darkSlateBlueTintColor:
            button.tintColor = UIColor(named: .darkSlateBlue)
        case .rosyPinkTintColor:
            button.tintColor = UIColor(named: .rosyPink)
        case .buttonInHeader:
            button.titleLabel?.font = UIFont.regularFont(ofSize: 14.0)
            button.setTitleColor(.white, for: .normal)
        case .themeColorToggle:
            button.titleLabel?.font = UIFont.regularFont(ofSize: 14.0)
            button.setTitleColor(UIColor(named: .darkSlateBlue), for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setBackgroundImage(UIImage.makeImage(of: UIColor(named: .rosyPink)), for: .selected)
            button.tintColor = .clear
        case .telreserveOpenurl:
            button.setTitleColor(UIColor(named: .rosyPink), for: .normal)
        case .showMap:
            button.imageView?.tintColor = UIColor(named: .rosyPink)
            break
        case .retryButton:
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(named: .rosyPink).cgColor
            button.tintColor = UIColor(named: .rosyPink)
            button.layer.cornerRadius = 23.0
            button.clipsToBounds = true

        case .withoutLogin:
            button.titleLabel?.font = UIFont.boldRegularFont(ofSize: 14.0)
            button.setTitleColor(UIColor(named: .rosyPink), for: .normal)
        }
    }
}

extension UIButton {
    func apply(style: UIButtonStyle) {
        style.apply(to: self)
    }
}
