//
//  PagingManager.swift
//  PagingManagerSample
//
//  Created by msano on 2017/08/22.
//  Copyright © 2017年 Ohako, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol PagingResultCaching {
    associatedtype PagingItem
    associatedtype ServiceError: Error
    var items: Property<[PagingItem]> { get }
    var error: Signal<PagingError<ServiceError>, NoError> { get }
}

protocol PagingControllable {
    // state
    var hasNextPage: Property<Bool> { get }
    var isRefreshing: Property<Bool> { get }
    var isFetchingNextPage: Property<Bool> { get }
    var isLoading: Property<Bool> { get }

    // action
    func refreshItems()
    func fetchNextPageItems()
}

// swiftlint:disable:next generic_type_name
class PagingManager<Item, _ServiceError: Error>: PagingResultCaching, PagingControllable {

    typealias PagingItem = Item
    typealias ServiceError = _ServiceError

    private let _items = MutableProperty<[PagingItem]>([])
    private let pagingManagerErrorPipe = Signal<PagingError<ServiceError>, NoError>.pipe()

    private let _hasNextPage = MutableProperty<Bool>(true)
    private let _isRefreshing = MutableProperty<Bool>(false)
    private let _isFetchingNextPage = MutableProperty<Bool>(false)
    private let _loading: Property<Bool> // inner state

    private let refreshItemsPipe = Signal<Void, NoError>.pipe()
    private let fetchNextPageItemsPipe = Signal<Void, NoError>.pipe()

    private var shouldIgnoreNextPageResult: Bool = false

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    init(
        responseProducerAtStartIndex:
        @escaping (Int)
        -> SignalProducer<ResponseWithHasNextPage<PagingItem>, ServiceError>
        ) {

        _loading = _isRefreshing.or(_isFetchingNextPage)

        // refresh items
        refreshItemsPipe.output
            .on { [weak self] _ in
                self?._isRefreshing.value = true
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isFetchingNextPage.value {
                    strongSelf.shouldIgnoreNextPageResult = true
                }
            }
            .flatMap(.latest) { [weak self] _
                -> SignalProducer<Result<ResponseWithHasNextPage<PagingItem>, ServiceError>, NoError> in

                guard self != nil else {
                    return .empty
                }
                return responseProducerAtStartIndex(0)
                    .resultWrapped()
            }
            .on { [weak self] _ in
                self?._isRefreshing.value = false
            }
            .observeValues { [weak self] result in
                switch result {
                case .success(let value):
                    self?._items.value = value.items
                    self?._hasNextPage.value = value.hasNextPage
                case .failure(let error):
                    self?.pagingManagerErrorPipe.input.send(value: .service(error))
                }
            }

        // next page
        _loading
            .producer
            .sample(on: fetchNextPageItemsPipe.output)
            .filter { loading in
                return !loading
            }
            .filter { [weak self] _ -> Bool in
                guard let strongSelf = self else {
                    return false
                }
                return strongSelf.hasNextPage.value
            }
            .on { [weak self] _ in
                self?._isFetchingNextPage.value = true
            }
            .flatMap(.latest) { [weak self] _
                -> SignalProducer<Result<ResponseWithHasNextPage<PagingItem>, ServiceError>, NoError> in

                guard let strongSelf = self else {
                    return .empty
                }
                return responseProducerAtStartIndex(strongSelf.items.value.count)
                    .resultWrapped()
            }
            .on { [weak self] _ in
                self?._isFetchingNextPage.value = false
            }
            .startWithValues { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.shouldIgnoreNextPageResult {
                    strongSelf.shouldIgnoreNextPageResult = false
                    return
                }
                switch result {
                case .success(let value):
                    strongSelf._items.value += value.items
                    strongSelf._hasNextPage.value = value.hasNextPage
                case .failure(let error):
                    strongSelf.pagingManagerErrorPipe.input.send(value: .service(error))
                }
        }
    }
}

// MARK: - PagingResultCaching
extension PagingManager {
    var items: Property<[PagingItem]> {
        return Property(_items)
    }
    var error: Signal<PagingError<ServiceError>, NoError> {
        return pagingManagerErrorPipe.output
    }
}

// MARK: - PagingControllable
extension PagingManager {
    var hasNextPage: Property<Bool> {
        return Property(_hasNextPage)
    }
    var isRefreshing: Property<Bool> {
        return Property(_isRefreshing)
    }
    var isFetchingNextPage: Property<Bool> {
        return Property(_isFetchingNextPage)
    }
    var isLoading: Property<Bool> {
        return _loading
    }

    func refreshItems() {
        refreshItemsPipe.input.send(value: ())
    }
    func fetchNextPageItems() {
        fetchNextPageItemsPipe.input.send(value: ())
    }
}
