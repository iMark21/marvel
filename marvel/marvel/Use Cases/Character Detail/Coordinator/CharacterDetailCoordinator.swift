//
//  CharacterDetailCoordinator.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
import RxSwift

// MARK: - I/O

extension CharacterDetailCoordinator {
    
    struct Input {
        let router: Router
        let repository: MarvelRepositoryProtocol
        let component: CharacterComponentProtocol
        let schedulers: AppSchedulers
    }
}

// MARK: - Class

class CharacterDetailCoordinator: BaseCoordinator {
    
    /// I/O
    let input: Input
    
    /// Private
    private let disposeBag: DisposeBag
    
    init(router: Router,
         repository: MarvelRepositoryProtocol,
         component: CharacterComponentProtocol,
         schedulers: AppSchedulers) {
                
        self.input = Input.init(
            router: router,
            repository: repository,
            component: component,
            schedulers: schedulers
        )
        self.disposeBag = DisposeBag()
        super.init(scheduler: schedulers.main)
    }
    
    override func start() -> Observable<Void> {
        guard let viewController = CharacterDetailViewController.instantiate(
                storyboardName: Storyboard.main.name) else {
            return .never()
        }
        
        let viewModel = CharacterDetailViewModel.init(
            repository: input.repository,
            component: input.component,
            schedulers: input.schedulers
        )
        viewController.viewModel = viewModel
        
        return input.router.rx.push(
            viewController,
            isAnimated: true
        )
    }
}
