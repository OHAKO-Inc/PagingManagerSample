//
//  PagingViewModel.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/11.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol PagingViewModeling {

    // view states (view model -> view)
    var loadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling { get }
    var emptyDataViewModel: EmptyDataViewModeling { get }
    var loadingErrorViewModel: LoadingErrorViewModeling { get }
    var isEmptyDataViewHidden: Property<Bool> { get }
    var isLoadingErrorViewHidden: Property<Bool> { get }
    var refreshControlEnd: Signal<Void, NoError> { get }
    var cellModels: Property<[SampleCellModeling]> { get }

    // view -> view model
    func viewWillAppear()
    func pullToRefreshTriggered()
    func tableViewReachedAtBottom()
}

final class PagingViewModel {

    let loadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling = LoadMoreIndicatorViewModel()
    let emptyDataViewModel: EmptyDataViewModeling
    let loadingErrorViewModel: LoadingErrorViewModeling
    private let _isEmptyDataViewHidden = MutableProperty<Bool>(true)
    private let _isLoadingErrorViewHidden = MutableProperty<Bool>(true)
    private let tableViewReachedAtBottomPipe = Signal<Void, NoError>.pipe()
    private let pullToRefreshTriggeredPipe = Signal<Void, NoError>.pipe()
    private let viewWillAppearPipe = Signal<Void, NoError>.pipe()
    private let refreshControlEndPipe = Signal<Void, NoError>.pipe()
    private let _cellModels = MutableProperty<[SampleCellModeling]>([])
    private let _manager: PagingManager<String, NSError>
    init(
        manager: PagingManager<String, NSError>,
        emptyDataViewModel: EmptyDataViewModeling,
        loadingErrorViewModel: LoadingErrorViewModeling
        ) {
        self.emptyDataViewModel = emptyDataViewModel
        self.loadingErrorViewModel = loadingErrorViewModel
        _manager = manager
        _cellModels <~ manager.items.producer.map { testValues -> [SampleCellModeling] in
            return testValues.map(SampleCellModel.init)
        }

        manager.isLoading
            .signal
            .filter { $0 }
            .observeValues { [weak self] _ in
                self?._isLoadingErrorViewHidden.value = true
        }

        // empty view
        Signal.combineLatest(
            manager.isLoading.signal,
            _cellModels.signal
            )
            .observeValues { [weak self] isLoading, cellModels in
                self?._isEmptyDataViewHidden.value = isLoading ? true : !cellModels.isEmpty
        }

        // refresh control ending
        manager
            .isRefreshing
            .producer
            .filter { !$0 }
            .map { _ in return () }
            .start(refreshControlEndPipe.input)

        // load more indicator
        manager
            .isFetchingNextPage
            .producer
            .startWithValues { [weak self] isFetchingNextPage in
                self?.loadMoreIndicatorViewModel.updateState(to: isFetchingNextPage ? .loading : .hidden)
        }

        // load more
        tableViewReachedAtBottomPipe
            .output
            .observeValues {[weak self] _ in
                self?._manager.fetchNextPageItems()
        }

        // reload
        Signal.merge(
            pullToRefreshTriggeredPipe.output,
            emptyDataViewModel.retryTappedOutput,
            loadingErrorViewModel.retryTappedOutput
            )
            .observe(on: UIScheduler())
            .observeValues {[weak self]  _ in
                self?._manager.refreshItems()
        }

        viewWillAppearPipe.output.observeValues {[weak self]  _ in
           self?._manager.refreshItems()
        }

    }

}

extension PagingViewModel: PagingViewModeling {
    var cellModels: Property<[SampleCellModeling]> {
        return Property(_cellModels)
    }
    var isLoadingErrorViewHidden: Property<Bool> {
        return Property(_isLoadingErrorViewHidden)
    }

    var isEmptyDataViewHidden: Property<Bool> {
        return Property(_isEmptyDataViewHidden)
    }

    var refreshControlEnd: Signal<Void, NoError> {
        return refreshControlEndPipe.output
    }
    func tableViewReachedAtBottom() {
        tableViewReachedAtBottomPipe.input.send(value: ())
    }

    func pullToRefreshTriggered() {
        pullToRefreshTriggeredPipe.input.send(value: ())
    }

    func viewWillAppear() {
        viewWillAppearPipe.input.send(value: ())
    }

}
