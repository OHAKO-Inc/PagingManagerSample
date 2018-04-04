//
//  UICollectionView+Type.swift
//  OfficeReception
//
//  Created by Yoshikuni Kato on 2016/04/14.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension UICollectionView {
    public func registerNibForCellWithType<T: UICollectionViewCell>(_ type: T.Type) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: Bundle(for: type))
        register(nib, forCellWithReuseIdentifier: className)
    }

    public func registerClassForCellWithType<T: UICollectionViewCell>(_ type: T.Type) {
        let className = String(describing: type)
        register(type, forCellWithReuseIdentifier: className)
    }

    public func dequeueReusableCellWithType<T: UICollectionViewCell>(
        _ type: T.Type,
        forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withReuseIdentifier: String(describing: type),
            for: indexPath) as! T // swiftlint:disable:this force_cast
    }
}
