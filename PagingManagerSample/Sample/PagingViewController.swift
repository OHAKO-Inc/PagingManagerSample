//
//  PagingViewController.swift
//  PagingManager
//
//  Created by 張穎 on 2017/09/11.
//  Copyright © 2017年 張穎. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

final class PagingViewController: UIViewController {
    var viewModel: PagingViewModeling!
    var pagingManager: PagingManager<String, NSError>!

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var emptyView: EmptyDataView!
    @IBOutlet weak var loadErrorView: LoadingErrorView!
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        pagingManager = PagingViewController.makeSamplePagingManager()
        viewModel = PagingViewModel(
            manager: pagingManager,
            emptyDataViewModel: EmptyDataViewModel(
                image: nil, // TODO: add image
                message: "Data is Empty",
                isImageHidden: true,
                isRetryButtonHidden: false
            ),
            loadingErrorViewModel: LoadingErrorViewModel(errorMessage: "通信エラー"))
        configureTableView()
        bindViewModel()
        tableview.dataSource = self
        tableview.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

}

private extension PagingViewController {
    func configureTableView() {
        tableview.registerNibForCellWithType(PagingSampleViewCell.self)
        tableview.reactive.reloadData <~ viewModel.cellModels.map { _ in return () }
        tableview.tableFooterView = LoadMoreIndicatorView(
            frame: CGRect(x: 0, y: 0, width: tableview.frame.width, height: 120.0),
            viewModel: viewModel.loadMoreIndicatorViewModel
        )
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(PagingViewController.refresh(sender:)),
            for: .valueChanged)
    }
}

extension PagingViewController {

    func bindViewModel() {

        viewModel
            .refreshControlEnd
            .signal
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.refreshControl.endRefreshing()
        }

        self.emptyView.configure(with: viewModel.emptyDataViewModel)
        self.emptyView.reactive.isHidden <~ viewModel.isEmptyDataViewHidden.signal

        self.loadErrorView.configure(with: viewModel.loadingErrorViewModel)
        self.loadErrorView.reactive.isHidden <~ viewModel.isLoadingErrorViewHidden

    }

    @objc private func refresh(sender: UIRefreshControl) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.pullToRefreshTriggered()
        }

    }
}

// MARK: - UITableViewDataSource
extension  PagingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithType(PagingSampleViewCell.self, forIndexPath: indexPath)
        if indexPath.row < viewModel.cellModels.value.count {
            cell.configure(with: viewModel.cellModels.value[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
}

// MARK: - UITableViewDelegate
extension PagingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        viewModel.cellSelected(at: indexPath.row)
    }
}

extension PagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollingSize = tableview.contentOffset.y + tableview.frame.size.height

        if  scrollingSize > tableview.contentSize.height && tableview.isDragging {
            viewModel.tableViewReachedAtBottom()
        }
    }
}

extension PagingViewController {
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
