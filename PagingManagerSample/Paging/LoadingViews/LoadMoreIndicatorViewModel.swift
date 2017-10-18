//
//  LoadMoreIndicatorViewModel.swift
//  PagingManagerSample
//
//  Created by msano on 2017/08/21.
//  Copyright © 2017年 Ohako, Inc. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class LoadMoreIndicatorViewModel {

    let state: MutableProperty<LoadMoreIndicatorState>

    init() {
        state = MutableProperty<LoadMoreIndicatorState>(.hidden)
    }
}

enum LoadMoreIndicatorState {
    case hidden
    case loading
//    case noMorePage
}
