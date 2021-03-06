//
//  SamplePagingViewModel.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/11.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol SamplePagingViewModeling {

    // view states (view model -> view)
    var cellModels: Property<[SampleCellModeling]> { get }

    var emptyDataViewModel: EmptyDataViewModeling { get }
    var loadingErrorViewModel: LoadingErrorViewModeling { get }
    var loadingIndicatorViewModel: LoadingIndicatorViewModeling { get }
    var loadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling { get }

    var isEmptyDataViewHidden: Property<Bool> { get }
    var isLoadingErrorViewHidden: Property<Bool> { get }
    var isLoadingIndicatorViewHidden: Property<Bool> { get }

    var shouldStopRefreshControl: Signal<Void, NoError> { get }

    // view -> view model
    func viewWillAppear()
    func pullToRefreshTriggered()
    func tableViewReachedAtBottom()
}

final class SamplePagingViewModel {

    private let _manager: PagingManager<String, NSError>

    let cellModels: Property<[SampleCellModeling]>

    let emptyDataViewModel: EmptyDataViewModeling
    let loadingErrorViewModel: LoadingErrorViewModeling
    let loadingIndicatorViewModel: LoadingIndicatorViewModeling
    let loadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling

    private let _isEmptyDataViewHidden = MutableProperty<Bool>(true)
    private let _isLoadingErrorViewHidden = MutableProperty<Bool>(true)
    private let _isLoadingIndicatorViewHidden = MutableProperty<Bool>(true)

    private let shouldStopRefreshControlPipe = Signal<Void, NoError>.pipe()

    private let viewWillAppearPipe = Signal<Void, NoError>.pipe()
    private let pullToRefreshTriggeredPipe = Signal<Void, NoError>.pipe()
    private let tableViewReachedAtBottomPipe = Signal<Void, NoError>.pipe()

    // swiftlint:disable:next function_body_length
    init(
        manager: PagingManager<String, NSError>,
        emptyDataViewModel: EmptyDataViewModeling,
        loadingErrorViewModel: LoadingErrorViewModeling,
        loadingIndicatorViewModel: LoadingIndicatorViewModeling,
        loadMoreIndicatorViewModel: LoadMoreIndicatorViewModeling
        ) {

        _manager = manager

        cellModels = manager.items.map { items -> [SampleCellModeling] in
            return items.map(SampleCellModel.init)
        }

        self.emptyDataViewModel = emptyDataViewModel
        self.loadingErrorViewModel = loadingErrorViewModel
        self.loadingIndicatorViewModel = loadingIndicatorViewModel
        self.loadMoreIndicatorViewModel = loadMoreIndicatorViewModel

        // empty view
        Signal.combineLatest(
            manager.isLoading.signal,
            cellModels.signal
            )
            .observeValues { [weak self] isLoading, cellModels in
                self?._isEmptyDataViewHidden.value = isLoading ? true : !cellModels.isEmpty
        }

        // error view
        manager.isLoading
            .signal
            .filter { $0 }
            .observeValues { [weak self] _ in
                self?._isLoadingErrorViewHidden.value = true
        }

        manager.error
            .observeValues { [weak self] error in
                self?.loadingErrorViewModel.updateErrorMessage(to: error.localizedDescription)
                self?._isLoadingErrorViewHidden.value = false
        }

        // load more indicator
        Property.combineLatest(manager.isFetchingNextPage, manager.hasNextPage)
            .producer
            .map { isFetchingNextPage, hasNextPage -> LoadMoreIndicatorState in
                return isFetchingNextPage ? .loading : (hasNextPage ? .hidden : .noMorePage)
            }
            .startWithValues { [weak self] loadMoreState in
                self?.loadMoreIndicatorViewModel.updateState(to: loadMoreState)
        }

        // load more action
        tableViewReachedAtBottomPipe
            .output
            .observeValues { [weak self] _ in
                self?._manager.fetchNextPageItems()
        }

        // refresh control ending
        manager
            .isRefreshing
            .producer
            .filter { !$0 }
            .map { _ in return () }
            .start(shouldStopRefreshControlPipe.input)

        // reload action
        Signal.merge(
            pullToRefreshTriggeredPipe.output,
            emptyDataViewModel.retryTappedOutput,
            loadingErrorViewModel.retryTappedOutput,
            viewWillAppearPipe.output
            )
            .observeValues { [weak self] _ in
                self?._manager.refreshItems()
        }

        // loading view
        _isLoadingIndicatorViewHidden <~ SignalProducer.combineLatest(
            manager.items.producer,
            manager.isRefreshing.producer
            )
            .map { items, isRefreshing -> Bool in
                return items.isEmpty && isRefreshing
            }
            .map { !$0 }
            .skipRepeats()
    }

}

extension SamplePagingViewModel: SamplePagingViewModeling {
    var isEmptyDataViewHidden: Property<Bool> {
        return Property(_isEmptyDataViewHidden)
    }
    var isLoadingErrorViewHidden: Property<Bool> {
        return Property(_isLoadingErrorViewHidden)
    }
    var isLoadingIndicatorViewHidden: Property<Bool> {
        return Property(_isLoadingIndicatorViewHidden)
    }

    var shouldStopRefreshControl: Signal<Void, NoError> {
        return shouldStopRefreshControlPipe.output
    }

    func viewWillAppear() {
        viewWillAppearPipe.input.send(value: ())
    }
    func pullToRefreshTriggered() {
        pullToRefreshTriggeredPipe.input.send(value: ())
    }
    func tableViewReachedAtBottom() {
        tableViewReachedAtBottomPipe.input.send(value: ())
    }
}
