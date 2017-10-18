//
//  LoadingIndicatorViewModel.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 2016/09/20.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

protocol LoadingIndicatorViewModelType {
    var loadingMessage: String { get }
}

struct LoadingIndicatorViewModel: LoadingIndicatorViewModelType {
    let loadingMessage: String
}
