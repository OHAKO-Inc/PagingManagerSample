//
//  SamplePagingViewModelSpec.swift
//  PagingManagerSample
//
//  Created by Yoshikuni Kato on 12/31/17.
//  Copyright © 2017 張穎. All rights reserved.
//

import Quick
import Nimble
import ReactiveSwift
import Result
import Foundation

@testable import PagingManagerSample

class SamplePagingViewModelSpec: QuickSpec {
    override func spec() {

        var viewModel: SamplePagingViewModeling!
        beforeEach {
            let pagingManager = SamplePagingViewController.makeSamplePagingManager()
            viewModel = SamplePagingViewModel(
                manager: pagingManager,
                emptyDataViewModel: EmptyDataViewModel(image: nil, message: "", isImageHidden: true),
                loadingErrorViewModel: LoadingErrorViewModel(errorMessage: "error")
            )
        }

        describe("viewWillAppear") {
            context("first appear") {
                it("shows loading view") {
                    // arrange
                    var loadingViewHiddenUpdates = [Bool]()
                    viewModel.isLoadingViewHidden
                        .producer
                        .startWithValues { isLoadingViewHidden in
                        loadingViewHiddenUpdates.append(isLoadingViewHidden)
                    }

                    // act
                    viewModel.viewWillAppear()

                    // assert
                    expect(loadingViewHiddenUpdates).toEventually(
                        equal([true, false, true]),
                        timeout: 3.0
                    )
                }
            }
        }

        describe("pullToRefreshTriggered") {
            it("doesn't show loading view") {
                // arrange
                var loadingViewHiddenUpdates = [Bool]()
                viewModel.isLoadingViewHidden
                    .producer
                    .startWithValues { isLoadingViewHidden in
                    loadingViewHiddenUpdates.append(isLoadingViewHidden)
                }

                // act
                viewModel.pullToRefreshTriggered()

                // assert
                expect(loadingViewHiddenUpdates).to(equal([true]))
            }
        }
    }
}
