//
//  PagingMangerSpec.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/12.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Quick
import Nimble
import ReactiveSwift
import Result
import Foundation

@testable import PagingManagerSample

class PagingMangerSpec: QuickSpec {

    // swiftlint:disable:next function_body_length
    override func spec() {

        var networkShouldSucceed: Bool = true
        var hasNextPageInResponse: Bool = true

        var pagingManager: PagingManager<Int, NSError>!

        var dataSource: ((Int) -> SignalProducer<ResponseWithHasNextPage<Int>, NSError>)!

        beforeEach {
            dataSource = { startIndex -> SignalProducer<ResponseWithHasNextPage<Int>, NSError> in
                let responseProducer: SignalProducer<ResponseWithHasNextPage<Int>, NSError>
                if networkShouldSucceed {
                    var responseItems = [Int]()
                    for index in 0..<5 {
                        responseItems.append(startIndex + index)
                    }
                    let response = ResponseWithHasNextPage(
                        items: responseItems,
                        hasNextPage: hasNextPageInResponse
                    )
                    responseProducer = SignalProducer(value: response)
                } else {
                    responseProducer = SignalProducer(error: NSError(domain: "", code: 100, userInfo: nil))
                }

                return responseProducer.delay(0.2, on: QueueScheduler())
            }

            pagingManager = PagingManager<Int, NSError>(responseProducerAtStartIndex: dataSource)
        }

        describe("refreshItems") {
            context("network success") {

                beforeEach {
                    networkShouldSucceed = true
                    hasNextPageInResponse = false
                }

                it("gets items") {
                    // arrange
                    expect(pagingManager.items.value.count) == 0

                    // act
                    pagingManager.refreshItems()

                    // assert
                    expect(pagingManager.items.value.count).toEventually(beGreaterThan(0))
                }

                it("updates hasNextPage") {
                    // arrange
                    var hasNextPageUpdates = [Bool]()
                    pagingManager.hasNextPage.producer.startWithValues { hasNextPageUpdates.append($0) }
                    hasNextPageInResponse = false

                    // act
                    pagingManager.refreshItems()

                    // assert
                    expect(hasNextPageUpdates).toEventually(equal([true, false]))
                }

            }

            context("network fail") {

                beforeEach {
                    networkShouldSucceed = false
                }

                it("sends error") {
                    // arrange
                    var errors = [PagingError<NSError>]()
                    pagingManager.error.observeValues {
                        errors.append($0)
                    }

                    // act
                    pagingManager.refreshItems()

                    // assert
                    let expectedError = PagingError.service(NSError(domain: "", code: 100, userInfo: nil))
                    expect(errors).toEventually(equal([expectedError]))
                }
            }

            it("updates isRefreshing") {
                // arrange
                var isRefreshingUpdates = [Bool]()
                pagingManager.isRefreshing.producer.startWithValues { isRefreshingUpdates.append($0) }

                // act
                pagingManager.refreshItems()

                // assert
                expect(isRefreshingUpdates).toEventually(equal([false, true, false]))
            }
        }

        describe("fetchNextPageItems") {
            context("network success") {

                beforeEach {
                    networkShouldSucceed = true
                }

                it("populates items") {
                    // arrange
                    hasNextPageInResponse = true
                    pagingManager.refreshItems()
                    pagingManager.items.signal
                        .take(first: 1)
                        .observeValues { items in
                            expect(items).to(equal([0, 1, 2, 3, 4]))

                            // act
                            pagingManager.fetchNextPageItems()
                    }

                    // assert
                    expect(pagingManager.items.value).toEventually(equal([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
                }

                it("updates hasNextPage") {
                    var hasNextPageUpdates = [Bool]()
                    // arrange
                    pagingManager.hasNextPage.producer.startWithValues { hasNextPageUpdates.append($0) }

                    hasNextPageInResponse = true
                    pagingManager.refreshItems()
                    pagingManager.items.signal
                        .take(first: 1)
                        .observeValues { items in
                            expect(items).to(equal([0, 1, 2, 3, 4]))
                            hasNextPageInResponse = false

                            // act
                            pagingManager.fetchNextPageItems()
                        }

                    // assert
                    expect(hasNextPageUpdates).toEventually(equal([true, true, false]))
                }

            }

            context("network fail") {

                beforeEach {
                    networkShouldSucceed = false
                }

                it("sends error") {
                    // arrange
                    var errors = [PagingError<NSError>]()
                    pagingManager.error.observeValues {
                        errors.append($0)
                    }

                    // act
                    pagingManager.fetchNextPageItems()

                    // assert
                    let expectedError = PagingError.service(NSError(domain: "", code: 100, userInfo: nil))
                    expect(errors).toEventually(equal([expectedError]))
                }
            }

            it("updates isFetchingNextPage") {
                // arrange
                var isFetchingNextPageUpdates = [Bool]()
                hasNextPageInResponse = true
                pagingManager.isFetchingNextPage.producer.startWithValues { isFetchingNextPageUpdates.append($0) }

                // act
                pagingManager.fetchNextPageItems()

                // assert
                expect(isFetchingNextPageUpdates).toEventually(equal([false, true, false]))
            }
        }

    }
}
extension PagingError: Equatable {
    public static func == (lhs: PagingError, rhs: PagingError) -> Bool {
        return lhs.serviceError.localizedDescription == rhs.serviceError.localizedDescription
    }

}
