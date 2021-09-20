//
//  CharactersListViewController.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import UIKit
import RxSwift

class CharactersListViewController: UIViewController {

    // MARK: Public vars
    var viewModel: CharactersListViewModelProtocol?
    
    // MARK: Private vars
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setup()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        view.backgroundColor = .red
    }
    
    // MARK: - Setup ViewModel

    private func setupViewModel() {
        guard let viewModel = viewModel else {
            Log.debug("Characters List View Model not initialized")
            return
        }
        viewModel.output
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
