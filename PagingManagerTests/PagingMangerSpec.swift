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

        var errorflag: Bool = true
        var hasNextflag: Bool = true
        var pagingManager: PagingManager<Int, NSError>!

        var dataSource: ((Int) -> SignalProducer<ResponseWithHasNextPage<Int>, NSError>)!

        beforeEach {
            dataSource = { startIndex -> SignalProducer<ResponseWithHasNextPage<Int>, NSError> in
                let responseProducer: SignalProducer<ResponseWithHasNextPage<Int>, NSError>
                if errorflag {
                    var responseItems = [Int]()
                    for i in 0..<5 {
                        responseItems.append(startIndex + i)
                    }
                    let response = ResponseWithHasNextPage(
                        items: responseItems,
                        hasNextPage: hasNextflag
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
                    // setting network success
                    errorflag = true
                    hasNextflag = true
                }

                it("gets data") {
                    // arrange
                    expect(pagingManager.items.value.count) == 0

                    // act
                    pagingManager.refreshItems()

                    // assert
                    expect(pagingManager.items.value.count).toEventually(beGreaterThan(0))
                }

                it("changes hasNextPage") {
                    var refreshlist = [Bool]()
                    // arrange
                    pagingManager.hasNextPage.producer.startWithValues {  refreshlist.append($0) }

                    // act
                    pagingManager.refreshItems()

                    // assert
                    expect(refreshlist).toEventually(equal([true, true]))
                }

            }

            context("network failed") {

                beforeEach {
                    // set network failure
                    errorflag = false
                    hasNextflag = true
                }

                it("sends error") {
                    // arrange
                    var errorvalue = [PagingError<NSError>]()
                    pagingManager.error.observeValues {
                        errorvalue.append($0)
                    }

                    // act
                    pagingManager.refreshItems()

                    // assert
                    let expectedError = PagingError.service(NSError(domain: "", code: 100, userInfo: nil))
                    expect(errorvalue).toEventually(equal([expectedError]))
                }
            }

            it("changes isRefreshing") {
                var refreshlist = [Bool]()
                // arrange
                pagingManager.isRefreshing.producer.startWithValues {  refreshlist.append($0) }

                // act
                pagingManager.refreshItems()

                // assert
                expect(refreshlist).toEventually(equal([false, true, false]))
            }
        }

        describe("fetchNextPageItems") {
            context("network success") {

                beforeEach {
                    // set network failure
                    errorflag = true
                    hasNextflag = true
                }

                it("populate items") {
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

                it("test hasNextPage") {
                    var refreshlist = [Bool]()
                    // arrange
                    pagingManager.hasNextPage.producer.startWithValues {  refreshlist.append($0) }

                    // act
                    pagingManager.fetchNextPageItems()

                    // assert
                    expect(refreshlist).toEventually(equal([true, true]))
                }

            }

            context("network failed") {

                beforeEach {
                    // set network failure
                    errorflag = false
                    hasNextflag = true
                }

                it("sends error") {
                    // arrange
                    var errorvalue = [PagingError<NSError>]()
                    pagingManager.error.observeValues {
                        errorvalue.append($0)
                    }

                    // act
                    pagingManager.fetchNextPageItems()

                    // assert
                    let expectedError = PagingError.service(NSError(domain: "", code: 100, userInfo: nil))
                    expect(errorvalue).toEventually(equal([expectedError]))
                }
            }

            context("network success") {

                beforeEach {
                    // set network failure
                    errorflag = true
                    hasNextflag = false
                }
                it("test do not hasNextPage") {
                    var refreshlist = [Bool]()
                    // arrange
                    pagingManager.hasNextPage.producer.startWithValues {  refreshlist.append($0) }

                    // act
                    pagingManager.fetchNextPageItems()

                    // assert
                    expect(refreshlist).toEventually(equal([true, false]))
                }
            }

            it("changes isFetchingNextPage") {
                var refreshlist = [Bool]()
                // arrange
                pagingManager.isFetchingNextPage.producer.startWithValues {  refreshlist.append($0) }

                // act
                pagingManager.fetchNextPageItems()

                // assert
                expect(refreshlist).toEventually(equal([false, true, false]))
            }
        }

    }
}
extension PagingError: Equatable {
    public static func == (lhs: PagingError, rhs: PagingError) -> Bool {
        return lhs.serviceError.localizedDescription == rhs.serviceError.localizedDescription
    }

}
