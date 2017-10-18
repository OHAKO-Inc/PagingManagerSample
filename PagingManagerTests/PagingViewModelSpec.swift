//
//  PagingViewModelSpec.swift
//  PagingManagerSample
//
//  Created by 張穎 on 2017/09/20.
//  Copyright © 2017年 張穎. All rights reserved.
//

import Quick
import Nimble
import ReactiveSwift
import Result
import Foundation

@testable import PagingManagerSample

class PagingViewModelSpec: QuickSpec {
    override func spec() {
        var pagingManager: PagingManager<String, NSError>!
        var viewModel: PagingViewModeling!
        beforeEach {
            pagingManager = PagingViewController.makeSamplePagingManager()
            viewModel = PagingViewModel(
                manager: pagingManager,
                emptyDataViewModel: EmptyDataViewModel(
                    message: "Null",
                    isImageHidden: false,
                    isRetryButtonHidden: true
                ),
                loadingErrorViewModel: LoadingErrorViewModel(errorMessage: "通信エラー"))
        }

        describe("tableViewReachedAtBottom") {
            context("triple call test") {
                it("call test") {
                    // arrange
                    viewModel.tableViewReachedAtBottom()
                    viewModel.tableViewReachedAtBottom()
                    viewModel.tableViewReachedAtBottom()

                    // act
//                    pagingManager.refreshItems()

                    // assert
//                    expect(pagingManager.items.value.count).toEventually(beGreaterThan(0))
                }

            }

        }
    }
}
