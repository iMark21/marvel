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
    private let appSchedulers = MarvelAppSchedulers()
    
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
        
        tableView.register(UINib(
            nibName: CharacterComponentViewModel
                .Constants
                .cellIdentifier,
            bundle: nil
            ), forCellReuseIdentifier: CharacterComponentViewModel
                .Constants
                .cellIdentifier
        )
        
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
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CharacterComponentViewModel
                        .Constants
                        .cellIdentifier) as? CharacterComponent else {
                
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
        viewModel?.output
            .state
            .subscribe(onNext: { [weak self] state in
                //Evaluate state of view
                switch state {
                case .loading:
                    Log.debug("State Loading")
                case .nextPage:
                    self?.tableView.addLoading() {}
                case .loaded:
                    Log.debug("State Loaded")
                    self?.tableView.stopLoading()
                case .error(let error):
                    Log.debug("State " + error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }

    private func setup() {
        viewModel?.setup()
    }
    
}
