//
//  KeyboardNotificationReceiving.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/09/09.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public protocol KeyboardNotificationReceiving {
    func handleKeyboardWillShow(_ notification: Notification)
    func handleKeyboardWillHide(_ notification: Notification)
    func animationsWhenKeyboardWillMove(keyboardRect: CGRect, show: Bool)
}

public extension KeyboardNotificationReceiving {

    public func handleKeyboardWillShow(_ notification: Notification) {
        keyboardWillMove(notification, show: true)
    }

    public func handleKeyboardWillHide(_ notification: Notification) {
        keyboardWillMove(notification, show: false)
    }

    private func handleKeyboardNotification(_ notification: Notification) -> (keyboardRect: CGRect, duration: TimeInterval, curve: NSNumber)? {
        guard let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            else {
                return nil
        }
        return (keyboardRect, duration, curve)
    }

    private func keyboardWillMove(_ notification: Notification, show: Bool) {
        guard let param = handleKeyboardNotification(notification) else {
            return
        }
        UIView.animate(
            withDuration: param.duration,
            delay: 0.0,
            options: UIViewAnimationOptions(rawValue: UInt(truncating: param.curve)),
            animations: {
                self.animationsWhenKeyboardWillMove(keyboardRect: param.keyboardRect, show: show)
            },
            completion: nil
        )
    }
}
