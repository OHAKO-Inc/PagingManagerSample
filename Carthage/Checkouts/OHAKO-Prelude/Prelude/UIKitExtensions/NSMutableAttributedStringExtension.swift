//
//  NSMutableAttributedStringExtension.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/08/03.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    convenience public init(text: String, font: UIFont, lineSpacing: CGFloat = 0.0) {
        self.init(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        self.addAttributes([
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: self.length))
    }

}

public extension NSAttributedString {
    public func boundingRectForUITextView(width: CGFloat) -> CGRect {
        let options = unsafeBitCast(
            NSStringDrawingOptions.usesLineFragmentOrigin.rawValue /* | NSStringDrawingOptions.UsesFontLeading.rawValue */, // swiftlint:disable:this line_length
            to: NSStringDrawingOptions.self
        )
        return self.boundingRect(
            with: CGSize(
                width: width,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: options,
            context: nil
        )
    }

    public func boundingRectForUILabel(width: CGFloat) -> CGRect {
        let options = unsafeBitCast(
            NSStringDrawingOptions.usesLineFragmentOrigin.rawValue |
                NSStringDrawingOptions.truncatesLastVisibleLine.rawValue,
            to: NSStringDrawingOptions.self
        )
        return self.boundingRect(
            with: CGSize(
                width: width,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: options,
            context: nil
        )
    }
}
