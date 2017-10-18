//
//  LoadMoreIndicatorView.swift
//  PagingManagerSample
//
//  Created by msano on 2017/08/21.
//  Copyright © 2017年 Ohako, Inc. All rights reserved.
//

import UIKit
import Prelude

final class LoadMoreIndicatorView: UIView, XibInstantiatable {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var noMorePageLabel: UILabel!

    let viewModel: LoadMoreIndicatorViewModel

    init(frame: CGRect, viewModel: LoadMoreIndicatorViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)

        instantiate()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    fileprivate func bindViewModel() {
        viewModel.state
            .producer
            .startWithValues { [weak self] (state) in
                switch state {
                case .hidden:
                    DispatchQueue.main.async {
                        self?.activityIndicator.isHidden = true
                        self?.activityIndicator.stopAnimating()
                    }

                case .loading:
                    DispatchQueue.main.async {
                        self?.activityIndicator.isHidden = false
                        self?.activityIndicator.startAnimating()
                    }

                }
        }
    }

    static let height: CGFloat = 94.0

}
