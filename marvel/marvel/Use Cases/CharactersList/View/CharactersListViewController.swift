//
//  CharactersListViewController.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class CharactersListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Public vars
    var viewModel: CharactersListViewModelProtocol?
    var components: [CharacterComponentViewModel]?
        
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
        view.backgroundColor = .red
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
        /// Bind datasource
        bindTableView()
    }
    
    private func bindTableView() {
        viewModel?.output.datasource
            .bind(to: tableView.rx.items) { tableView, _, component in
                
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CharacterComponentViewModel
                        .Constants
                        .cellIdentifier) as? CharacterComponent else {
                
                return UITableViewCell()
            }
            cell.setup(component: component)
            return cell
        }.disposed(by: disposeBag)
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
                case .loaded:
                    Log.debug("State Loaded")
                case .error(let error):
                    Log.debug("State " + error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }

    private func setup() {
        viewModel?.setup()
    }
    
}
