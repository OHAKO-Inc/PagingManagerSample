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

protocol PagingContollable {
    // state
    var hasNextPage: Property<Bool> { get }
    var isRefreshing: Property<Bool> { get }
    var isFetchingNextPage: Property<Bool> { get }
    var isLoading: Property<Bool> { get }

    // action
    func refreshItems()
    func fetchNextPageItems()
}

struct ResponseWithHasNextPage<Item> {
    let items: [Item]
    let hasNextPage: Bool
}

// swiftlint:disable:next generic_type_name
class PagingManager<Item, _ServiceError: Error>: PagingResultCaching, PagingContollable {

    typealias PagingItem = Item
    typealias ServiceError = _ServiceError

    fileprivate let _items = MutableProperty<[PagingItem]>([])
    fileprivate let pagingManagerErrorPipe = Signal<PagingError<ServiceError>, NoError>.pipe()

    fileprivate let _hasNextPage = MutableProperty<Bool>(true)
    fileprivate let _isRefreshing = MutableProperty<Bool>(false)
    fileprivate let _isFetchingNextPage = MutableProperty<Bool>(false)
    fileprivate let _loading: Property<Bool> // inner state

    fileprivate let refreshItemsPipe = Signal<Void, NoError>.pipe()
    fileprivate let fetchNextPageItemsPipe = Signal<Void, NoError>.pipe()

    private var shouldIgnoreNextPageResult: Bool = false

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    init(
        responseProducerAtStartIndex:
        @escaping (Int)
        -> SignalProducer<ResponseWithHasNextPage<PagingItem>, ServiceError>
        ) {

        _loading = _isRefreshing.or(_isFetchingNextPage)

        refreshItemsPipe.output
            .on { [weak self] _ in
                self?._isRefreshing.value = true
                guard let _self = self else {
                    return
                }
                if _self.isFetchingNextPage.value {
                    _self.shouldIgnoreNextPageResult = true
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

        _loading
            .producer
            .sample(on: fetchNextPageItemsPipe.output)
            .filter { loading in
                return !loading
            }
            .filter { [weak self] _ -> Bool in
                guard let _self = self else {
                    return false
                }
                return _self.hasNextPage.value
            }
            .on { [weak self] _ in
                self?._isFetchingNextPage.value = true
            }
            .flatMap(.latest) { [weak self] _
                -> SignalProducer<Result<ResponseWithHasNextPage<PagingItem>, ServiceError>, NoError> in

                guard let _self = self else {
                    return .empty
                }
                return responseProducerAtStartIndex(_self.items.value.count)
                    .resultWrapped()
            }
            .on { [weak self] _ in
                self?._isFetchingNextPage.value = false
            }
            .startWithValues { [weak self] result in
                guard let _self = self else {
                    return
                }
                if _self.shouldIgnoreNextPageResult {
                    _self.shouldIgnoreNextPageResult = false
                    return
                }
                switch result {
                case .success(let value):
                    self?._items.value += value.items
                    self?._hasNextPage.value = value.hasNextPage
                case .failure(let error):
                    self?.pagingManagerErrorPipe.input.send(value: .service(error))
                }
        }
    }
}

extension PagingManager {
    var items: Property<[PagingItem]> {
        return Property(_items)
    }
    var error: Signal<PagingError<ServiceError>, NoError> {
        return pagingManagerErrorPipe.output
    }

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

enum PagingError<ServiceError: Error>: Error {
    case service(ServiceError)

    var serviceError: ServiceError {
        switch self {
        case .service(let error):
            return error
        }
    }
}

extension SignalProducer {
    func resultWrapped() -> SignalProducer<Result<Value, Error>, NoError> {
        return self
            .map { value -> Result<Value, Error> in
                return .success(value)
            }
            .flatMapError { error -> SignalProducer<Result<Value, Error>, NoError> in
                return .init(value: .failure(error))
        }
    }
}
