//
//  UIViewStyle.swift
//  EparkCure
//
//  Created by Yoshikuni Kato on 2017/05/11.
//  Copyright © 2017年 Ohako, Inc. All rights reserved.
//

import UIKit

// swiftlint:disable  type_body_length
enum UIViewStyle {

    enum GradientBackgroundStyle {
        case pink
        case searchInputPink(viewPoint: CGPoint, parentFrameSize: CGSize, inputColor :SearchInputColor)
        case skyblue // MEMO: 薬局用のため後対応
        // swiftlint:disable:next nesting
        enum SearchInputColor {
            case pink
            case white
            var startColor: UIColor {
                switch self {
                case .pink:
                    return UIColor(named: .rosePinkTwo)
                case .white:
                    return UIColor.white
                }
            }
            var endColor: UIColor {
                switch self {
                case .pink:
                    return UIColor(named: .rosyPink)

                case .white:
                    return UIColor.white
                }
            }
        }
    }

    enum RoundedAndShadowType {
        case cornerRadius4
        case cardInDetail
        case primarySubjectButton(isSelected: Bool)
        case darkishBlueShadow

        var cornerRadius: CGFloat {
            switch self {
            case .cornerRadius4, .cardInDetail, .darkishBlueShadow:
                return 4.0
            case .primarySubjectButton:
                return 6.0
            }
        }

        var backgroundColor: UIColor? {
            switch self {
            case .cornerRadius4, .cardInDetail:
                return .white
            case .primarySubjectButton(let isSelected):
                return isSelected ? UIColor(named: .rosyPink) : .white
            case .darkishBlueShadow:
                return nil
            }
        }

        var shadowOffset: CGSize {
            switch self {
            case .cornerRadius4, .primarySubjectButton:
                return CGSize(width: 0.0, height: 2.0)
            case .cardInDetail, .darkishBlueShadow:
                return CGSize(width: 0.0, height: 1.0)
            }
        }

        var shadowOpacity: Float {
            switch self {
            case .cornerRadius4, .darkishBlueShadow:
                return 0.08
            case .cardInDetail:
                return 0.20
            case .primarySubjectButton(let isSelected):
                return isSelected ? 0.20 : 0.08
            }
        }

        var shadowColor: CGColor {
            switch self {
            case .cornerRadius4, .cardInDetail:
                return UIColor(named: .darkSlateBlue).cgColor
            case .primarySubjectButton(let isSelected):
                return (isSelected ? UIColor(named: .rouge) : UIColor(named: .darkSlateBlue)).cgColor
            case .darkishBlueShadow:
                return UIColor(named: .darkishBlue).cgColor
            }
        }

        var shadowRadius: CGFloat {
            switch self {
            case .cornerRadius4, .primarySubjectButton, .darkishBlueShadow:
                return 4.0
            case .cardInDetail:
                return 2.0
            }
        }

    }

    case gradientBackground(style: GradientBackgroundStyle)
    case dropShadow
    case searchHeaderShadow
    case clinicCommonBackground
    case appColorBackground
    case whiteBackground
    case border
    case headerBorder
    case backgroundColorClear
    case rounded
    case roundedAndShadow(type: RoundedAndShadowType)
    case roundedveryLightPurple
    case myLocationCenterMarkerIcon
    case roundedAndTransparent
    case transparent24
    case transparent12
    case roundedAndWhite
    case roundedAnd12
    case cloudyBlue
    case paleGray

    // TODO: 対応方法について加藤さんと相談 http://qiita.com/akatsuki174/items/b4a8b8a51fd3be94ae05#cyclomaticcomplexityrule
    func apply(to view: UIView) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch self {
        case .gradientBackground(let style):
            switch style {
            case .pink:
                let layer = generateGradientLayer(
                    startColor: UIColor(named: .rosePinkTwo).cgColor,
                    endColor: UIColor(named: .rosyPink).cgColor,
                    startPoint: CGPoint(x: 0.0, y: 0.5),
                    endPoint: CGPoint(x: 1.0, y: 0.5),
                    locations: [0.025, 1])
                layer.frame = view.frame
                view.layer.sublayers?.forEach { sublayer in
                    if sublayer is CAGradientLayer {
                        sublayer.removeFromSuperlayer()
                    }
                }
                view.layer.addSublayer(layer)
            case .searchInputPink(let viewPoint, let parentFrameSize, let inputColor):

                let layer = generateGradientLayer(
                    startColor: inputColor.startColor.cgColor,
                    endColor: inputColor.endColor.cgColor,
                    startPoint: CGPoint(x: 0.0, y: 0.5),
                    endPoint: CGPoint(x: 1.0, y: 0.5),
                    locations: [0.05, 1])

                let hogeFrame = CGRect(
                    origin: CGPoint(x: -viewPoint.x, y: -viewPoint.y),
                    size: parentFrameSize
                )
                layer.frame = hogeFrame
                view.layer.sublayers?.forEach { sublayer in
                    if sublayer is CAGradientLayer {
                        sublayer.removeFromSuperlayer()
                    }
                }
                view.layer.addSublayer(layer)
            case .skyblue:
                print("stub")
            }
        case .dropShadow:
            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.shadowRadius = 3
            view.layer.shadowColor = UIColor(named: .shadow).cgColor
            view.layer.shadowOpacity = 0.06

            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            view.layer.shouldRasterize = true
            view.layer.rasterizationScale = UIScreen.main.scale
        case .searchHeaderShadow:
            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view.layer.shadowRadius = 4.0
            view.layer.shadowColor = UIColor(named: .darkSlateBlue).cgColor
            view.layer.shadowOpacity = 0.16

            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            view.layer.shouldRasterize = true
            view.layer.rasterizationScale = UIScreen.main.scale

        case .roundedAndShadow(let type):
            view.layer.shadowOffset = type.shadowOffset
            view.layer.shadowRadius = type.shadowRadius
            view.layer.shadowColor = type.shadowColor
            view.layer.shadowOpacity = type.shadowOpacity

            view.layer.cornerRadius = type.cornerRadius
            view.layer.shouldRasterize = true
            view.layer.rasterizationScale = UIScreen.main.scale

            if type.backgroundColor != nil {
                view.backgroundColor = type.backgroundColor
            }

        case .myLocationCenterMarkerIcon:
            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view.layer.shadowRadius = 4.0
            view.layer.shadowColor = UIColor(named: .rosyPink50).cgColor
            view.layer.shadowOpacity = 0.5

            view.layer.cornerRadius = 7.0
            view.layer.masksToBounds = false
            view.backgroundColor = UIColor(named: .rosyPink)

        case .clinicCommonBackground:
            view.backgroundColor = UIColor(named: .clinicCommonBackground)
        case .appColorBackground:
            view.backgroundColor = UIColor(named: .rosyPink)
        case .whiteBackground:
            view.backgroundColor = .white
        case .border:
            view.backgroundColor = UIColor(named: .divider)
        case .headerBorder:
            view.backgroundColor = UIColor(named: .greyish)
        case .backgroundColorClear:
            view.backgroundColor = .clear
        case .rounded:
            view.layer.cornerRadius = 4.0
            view.layer.masksToBounds = true

        case .roundedveryLightPurple:
            view.layer.cornerRadius = 4.0
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor(named: .veryLightPurple)

        case .roundedAndTransparent:
            view.layer.cornerRadius = 4.0
            view.layer.backgroundColor = UIColor.clear.cgColor
        case .transparent24:
            view.layer.backgroundColor = UIColor.white.cgColor
            view.layer.opacity = 0.24
        case .transparent12:
            view.layer.backgroundColor = UIColor.white.cgColor
            view.layer.opacity = 0.12
        case .roundedAndWhite:
            view.layer.cornerRadius = 4.0
            view.layer.backgroundColor = UIColor.white.cgColor
        case .roundedAnd12:
            view.layer.cornerRadius = 12.0
            view.layer.masksToBounds = true
        case .cloudyBlue:
            view.backgroundColor = UIColor(named: .cloudyBlueTwo)
        case .paleGray:
            view.backgroundColor = UIColor(named: .paleGray)
        }
    }

    private func generateGradientLayer(
        startColor: CGColor,
        endColor: CGColor,
        startPoint: CGPoint,
        endPoint: CGPoint,
        locations: [NSNumber]?) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [startColor, endColor]
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.locations = locations
        return layer
    }
}

extension UIView {
    func apply(style: UIViewStyle) {
        style.apply(to: self)
    }
}
