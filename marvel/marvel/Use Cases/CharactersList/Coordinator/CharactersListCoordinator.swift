//
//  CharactersListCoordinator.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

// MARK: - I/O

extension CharactersListCoordinator {
    
    struct Input {
        let router: Router
        let repository: MarvelRepositoryProtocol
    }
}

// MARK: - Class

class CharactersListCoordinator: BaseCoordinator {
    
    /// I/O
    let input: Input
    
    /// Private
    private let disposeBag: DisposeBag
    
    init(router: Router,
         repository: MarvelRepositoryProtocol = MarvelRepository()) {
        
        self.input = Input.init(
            router: router,
            repository: repository
        )
        self.disposeBag = DisposeBag()
    }
    
    override func start() -> Observable<Void> {
        guard let viewController = CharactersListViewController.instantiate(
                storyboardName: Storyboard.main.name) else {
            return .never()
        }
        
        let viewModel = CharactersListViewModel.init(
            repository: input.repository
        )
        viewController.viewModel = viewModel
        
        return input.router.rx.push(
            viewController,
            isAnimated: true
        )
    }
}
