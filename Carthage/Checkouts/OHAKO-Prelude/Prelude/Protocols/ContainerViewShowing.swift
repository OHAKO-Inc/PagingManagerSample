//
//  ContainerViewShowing.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/09/28.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public protocol ContainerViewShowing {
    func addChildViewController(_ childViewController: UIViewController, to containerView: UIView)
    func removeChildViewController(_ childViewController: UIViewController)
}

public extension ContainerViewShowing where Self: UIViewController {
    public func addChildViewController(_ childViewController: UIViewController, to containerView: UIView) {
        addChildViewController(childViewController)
        containerView.addFilledSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }

    public func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
}
