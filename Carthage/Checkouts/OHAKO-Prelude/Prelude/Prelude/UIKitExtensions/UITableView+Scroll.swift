//
//  UITableView+Scroll.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/10/04.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension UITableView {

    public func scrollToBottom(animated: Bool) {
        guard numberOfSections > 0 && numberOfRows(inSection: numberOfSections - 1) > 0 else {
            return
        }
        let indexPath = IndexPath(row:  numberOfRows(inSection: numberOfSections - 1)-1, section: numberOfSections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}
