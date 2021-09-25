//
//  CharacterDetailViewController.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Rx Variables
    var viewModel: CharacterDetailViewModelProtocol?
    var dataSource: RxTableViewSectionedReloadDataSource<MultipleSectionModel>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setup()
    }
    
    // MARK: - Setup View
    
    private func setupView(){
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.registerCell(type: DetailComponent.self)
        tableView.registerCell(type: MediaComponent.self)
        
        /// Background color
        tableView.separatorColor = .clear
        tableView.backgroundColor = .systemGroupedBackground
        
        /// DataSource
        setupDataSource()
        bindData()
    }
    
    private func setupDataSource() {
        dataSource =
            RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
                configureCell: { dataSource, table, idxPath, _ in
                    switch dataSource[idxPath] {
                    case let .HeaderSectionItem(component):
                        guard let cell = table.dequeueCell(withType: DetailComponent.self)
                                as? DetailComponent else {
                            return UITableViewCell()
                        }
                        cell.setup(component: component)
                        return cell
                    case .MediaSectionItem(components: let medias):
                        guard let cell = table.dequeueCell(withType: MediaComponent.self)
                                as? MediaComponent else {
                            return UITableViewCell()
                        }
                        cell.setup(medias: medias)
                        return cell
                    }
                },
                
                titleForHeaderInSection: { dataSource, index in
                    let section = dataSource[index]
                    return section.title
                }
            )
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
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        viewModel?.output
            .state
            .subscribe(onNext: { [weak self] state in
                //Evaluate state of view
                switch state {
                case .error(let error):
                    self?.showErrorAlert(error)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setup() {
        viewModel?.setup()
    }
}
