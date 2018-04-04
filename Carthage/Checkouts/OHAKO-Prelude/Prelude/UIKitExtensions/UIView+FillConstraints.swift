//
//  UIView+FillConstraints.swift
//  DataLoadingViewController
//
//  Created by Yoshikuni Kato on 2016/06/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public extension UIView {

    private func addFillConstraints(_ addedView: UIView) {
        addedView.translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: addedView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: addedView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: addedView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: addedView.trailingAnchor).isActive = true
    }

    public func addFilledSubview(_ view: UIView) {
        addSubview(view)
        addFillConstraints(view)
    }

    public func insertFilledSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        insertSubview(view, belowSubview: siblingSubview)
        addFillConstraints(view)
    }
}
