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

enum LoadMoreIndicatorState {
    case hidden
    case loading
    case noMorePage
}

protocol LoadMoreIndicatorViewModeling {
    var state: Property<LoadMoreIndicatorState> { get }

    func updateState(to newState: LoadMoreIndicatorState)
}

final class LoadMoreIndicatorViewModel {
    private let _state: MutableProperty<LoadMoreIndicatorState>

    init() {
        _state = MutableProperty<LoadMoreIndicatorState>(.hidden)
    }
}

// MARK: LoadMoreIndicatorViewModeling
extension LoadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling {
    var state: Property<LoadMoreIndicatorState> {
        return Property(_state)
    }
    func updateState(to newState: LoadMoreIndicatorState) {
        _state.value = newState
    }
}
