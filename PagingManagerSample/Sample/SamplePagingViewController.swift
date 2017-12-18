//
//  SamplePagingViewController.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/11.
//  Copyright © 2017年 張穎. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

final class SamplePagingViewController: UIViewController {

    var viewModel: PagingViewModeling!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataView: EmptyDataView!
    @IBOutlet weak var loadingErrorView: LoadingErrorView!
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        let pagingManager = SamplePagingViewController.makeSamplePagingManager()
        let emptyDataViewModel = EmptyDataViewModel(
            image: nil, // TODO: add image
            message: "Data is Empty",
            isImageHidden: true,
            isRetryButtonHidden: false
        )
        let loadingErrorViewModel = LoadingErrorViewModel(errorMessage: "Network error")

        viewModel = PagingViewModel(
            manager: pagingManager,
            emptyDataViewModel: emptyDataViewModel,
            loadingErrorViewModel: loadingErrorViewModel
        )
        configureTableView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

// MARK: - Private Methods
private extension SamplePagingViewController {
    func configureTableView() {
        tableView.registerNibForCellWithType(SampleCell.self)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(refresh(sender:)),
            for: .valueChanged
        )
        tableView.tableFooterView = LoadMoreIndicatorView(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120.0),
            viewModel: viewModel.loadMoreIndicatorViewModel
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    func bindViewModel() {

        viewModel
            .refreshControlEnd
            .signal
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.refreshControl.endRefreshing()
        }

        emptyDataView.configure(with: viewModel.emptyDataViewModel)
        emptyDataView.reactive.isHidden <~ viewModel.isEmptyDataViewHidden.signal

        loadingErrorView.configure(with: viewModel.loadingErrorViewModel)
        loadingErrorView.reactive.isHidden <~ viewModel.isLoadingErrorViewHidden

        tableView.reactive.reloadData <~ viewModel.cellModels.map { _ in return () }
    }

    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.pullToRefreshTriggered()
    }
}

// MARK: - UITableViewDataSource
extension SamplePagingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithType(SampleCell.self, forIndexPath: indexPath)
        if indexPath.row < viewModel.cellModels.value.count {
            cell.configure(with: viewModel.cellModels.value[indexPath.row])
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SamplePagingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        viewModel.cellSelected(at: indexPath.row)
    }
}

// MARK: - UIScrollViewDelegate
extension SamplePagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollingSize = tableView.contentOffset.y + tableView.frame.size.height

        if scrollingSize > tableView.contentSize.height && tableView.isDragging {
            viewModel.tableViewReachedAtBottom()
        }
    }
}

// MARK: - Sample methods
extension SamplePagingViewController {
    static func makeSamplePagingManager() -> PagingManager<String, NSError> {
        // swiftlint:disable:next line_length
        let responseProducer: (Int) -> SignalProducer<ResponseWithHasNextPage<String>, NSError> = { startIndex -> SignalProducer<ResponseWithHasNextPage<String>, NSError> in
            var responseItems = [String]()
            for i in 0..<5 {
                responseItems.append("\(startIndex + i)")
            }
            let response = ResponseWithHasNextPage(
                items: responseItems,
                hasNextPage: true
            )

            return SignalProducer(value: response)
                .delay(1.0, on: QueueScheduler())
        }

        return PagingManager(responseProducerAtStartIndex: responseProducer)
    }

}
