//
//  UITableView+Type.swift
//  DataLoadingViewController
//
//  Created by Yoshikuni Kato on 2016/06/23.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension UITableView {
    public func registerNibForCellWithType<T: UITableViewCell>(_ type: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }

    public func registerClassForCellWithType<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    public func dequeueReusableCellWithType<T: UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T // swiftlint:disable:this force_cast
    }

    // header footer view
    public func registerNibForHeaderFooterViewWithType<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    public func dequeueReusableHeaderFooterViewWithType<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T
    }

}
