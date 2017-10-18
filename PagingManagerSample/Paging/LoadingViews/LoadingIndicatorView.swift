//
//  LoadingIndicatorView.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 2016/06/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit
import Prelude

final class LoadingIndicatorView: UIView, XibInstantiatable {
    private var viewModel: LoadingIndicatorViewModelType?
    @IBOutlet weak var loadingMessageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instantiate()
    }

    func configure(with viewModel: LoadingIndicatorViewModelType) {
        self.viewModel = viewModel
        bind(viewModel)
    }

    private func bind(_ viewModel: LoadingIndicatorViewModelType) {
        loadingMessageLabel.text = viewModel.loadingMessage
        loadingMessageLabel.isHidden = viewModel.loadingMessage.isEmpty
    }

}
