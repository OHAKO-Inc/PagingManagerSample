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
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: String(describing: type))
    }

    public func registerClassForCellWithType<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }

    public func dequeueReusableCellWithType<T: UITableViewCell>(
        _ type: T.Type,
        forIndexPath indexPath: IndexPath
    ) -> T {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }

    // header footer view
    public func registerNibForHeaderFooterViewWithType<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }

    public func dequeueReusableHeaderFooterViewWithType<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T
    }

}
