//
//  CharactersListViewController.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CharactersListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Public vars
    var viewModel: CharactersListViewModelProtocol?
    var dataSource: RxTableViewSectionedAnimatedDataSource<ComponentsDataSource>?
    
    // MARK: Private RX vars
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setup()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        setupTableView()
        setupPager()
    }
    
    // MARK: - Table View
    
    private func setupTableView() {
        
        tableView.registerCell(type: CharacterComponent.self)
        
        ///Row selected
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(
                    at: indexPath,
                    animated: true
                )
            }).disposed(by: disposeBag)
        
        ///Item selected
        tableView
            .rx
            .modelSelected(CharacterComponentProtocol.self)
            .subscribe(onNext: { [weak self] component in
                self?.viewModel?
                    .output
                    .action
                    .onNext(.openDetail(component))
            }).disposed(by: disposeBag)
        
        /// Background color
        tableView.separatorColor = .clear
        tableView.backgroundColor = .systemGroupedBackground
        
        /// DataSource
        setupDataSource()
        bindData()
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<ComponentsDataSource>(
            configureCell: { dataSource, tableView, indexPath, component in
                guard let cell = tableView.dequeueCell(withType: CharacterComponent.self)
                        as? CharacterComponent else {
                    return UITableViewCell()
                }
                cell.setup(component: component)
                return cell
            })
        
        dataSource?.decideViewTransition = { (_, _, _)  in return RxDataSources.ViewTransition.reload }
        
    }
    
    private func bindData() {
        guard let dataSource = dataSource else { return }
        tableView.dataSource = nil
        
        viewModel?.output.dataSource
            .asDriver(onErrorJustReturn: [])
            .map { $0 }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupPager() {
        let loadNextPage = tableView
            .rx
            .reachedBottom()
            .skip(1)
        
        loadNextPage
            .asObservable()
            .throttle(.milliseconds(500),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if self?.tableView
                    .visibleCells
                    .isEmpty == false {
                    self?.viewModel?.loadNextPage()
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        let loadingViewController = LoadingViewController()

        viewModel?.output
            .state
            .subscribe(onNext: { [weak self] state in
                /// Evaluate state of view
                switch state {
                case .loading:
                    self?.add(loadingViewController)
                case .nextPage:
                    self?.tableView.addLoading() {}
                case .loaded:
                    loadingViewController.remove()
                    self?.tableView.stopLoading()
                case .error(let error):
                    self?.showErrorAlert(error)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setup() {
        viewModel?.setup()
    }
    
}
