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

    // MARK: - Properties
    // In real project, this ViewModel should be injected from outside of the ViewController.
    lazy var viewModel: SamplePagingViewModeling = {
        let pagingManager = SamplePagingViewController.makeSamplePagingManager()
        let emptyDataViewModel = EmptyDataViewModel(
            image: nil, // TODO: add image
            message: "Data is Empty",
            isImageHidden: true,
            isRetryButtonHidden: false
        )
        let loadingErrorViewModel = LoadingErrorViewModel(errorMessage: "Network error")
        let loadingIndicatorViewModel = LoadingIndicatorViewModel(loadingMessage: "Loading")

        return SamplePagingViewModel(
            manager: pagingManager,
            emptyDataViewModel: emptyDataViewModel,
            loadingErrorViewModel: loadingErrorViewModel,
            loadingIndicatorViewModel: loadingIndicatorViewModel
        )
    }()

    // MARK: - View Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataView: EmptyDataView!
    @IBOutlet weak var loadingErrorView: LoadingErrorView!
    @IBOutlet weak var loadingIndicatorView: LoadingIndicatorView!
    private var refreshControl = UIRefreshControl()

    @IBOutlet weak var currentResponseTypeLabel: UILabel!
    @IBAction func dataTapped(_ sender: Any) {
        kResponseType = .data
        currentResponseTypeLabel.text = "Data"
    }
    @IBAction func emptyTapped(_ sender: Any) {
        kResponseType = .empty
        currentResponseTypeLabel.text = "Empty"
    }
    @IBAction func errorTapped(_ sender: Any) {
        kResponseType = .error
        currentResponseTypeLabel.text = "Error"
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()

        currentResponseTypeLabel.text = "Data"
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

    @objc func refresh(sender: UIRefreshControl) {
        viewModel.pullToRefreshTriggered()
    }

    func bindViewModel() {
        tableView.reactive.reloadData <~ viewModel.cellModels.map { _ in return () }

        emptyDataView.configure(with: viewModel.emptyDataViewModel)
        emptyDataView.reactive.isHidden <~ viewModel.isEmptyDataViewHidden.signal

        loadingErrorView.configure(with: viewModel.loadingErrorViewModel)
        loadingErrorView.reactive.isHidden <~ viewModel.isLoadingErrorViewHidden

        loadingIndicatorView.configure(with: viewModel.loadingIndicatorViewModel)
        loadingIndicatorView.reactive.isHidden <~ viewModel.isLoadingIndicatorViewHidden

        viewModel
            .shouldStopRefreshControl
            .signal
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.refreshControl.endRefreshing()
        }
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
        return 80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

            let responseDataProducer: SignalProducer<ResponseWithHasNextPage<String>, NSError>

            switch kResponseType {
            case .data:
                let response = ResponseWithHasNextPage(
                    items: (0..<10).map { "\(startIndex + $0)" },
                    hasNextPage: startIndex < 10
                )
                responseDataProducer = SignalProducer(value: response)
                    .delay(1.0, on: QueueScheduler())

            case .empty:
                let response = ResponseWithHasNextPage<String>(
                    items: [],
                    hasNextPage: false
                )
                responseDataProducer = SignalProducer(value: response)
                    .delay(1.0, on: QueueScheduler())

            case .error:
                responseDataProducer = SignalProducer
                    .timer(interval: .seconds(1), on: QueueScheduler())
                    .flatMap(.latest) { _ -> SignalProducer<ResponseWithHasNextPage<String>, NSError> in
                        let error = NSError(
                            domain: "ohako.PagingManagerSample",
                            code: 0,
                            userInfo: [:]
                        )
                        return SignalProducer(error: error)
                }
            }

            return responseDataProducer
        }

        return PagingManager(responseProducerAtStartIndex: responseProducer)
    }

}

enum ResponseType {
    case data
    case empty
    case error
}

var kResponseType: ResponseType = .data
