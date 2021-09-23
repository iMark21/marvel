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
        let schedulers: AppSchedulers
    }
}

// MARK: - Class

class CharactersListCoordinator: BaseCoordinator {
    
    /// I/O
    let input: Input
    
    /// Private
    private let disposeBag: DisposeBag
    
    init(router: Router,
         repository: MarvelRepositoryProtocol,
         schedulers: AppSchedulers) {
                
        self.input = Input.init(
            router: router,
            repository: repository,
            schedulers: schedulers
        )
        self.disposeBag = DisposeBag()
        super.init(scheduler: schedulers.main)
    }
    
    override func start() -> Observable<Void> {
        guard let viewController = CharactersListViewController.instantiate(
                storyboardName: Storyboard.main.name) else {
            return .never()
        }
        
        let viewModel = CharactersListViewModel.init(
            repository: input.repository,
            schedulers: input.schedulers
        )
        
        viewModel.output.action
            .subscribe(onNext: { action in
                switch action {
                case .openDetail(let component):
                    self.openDetail(component: component)
                        .subscribe()
                        .disposed(by: self.disposeBag)
                }
            }).disposed(by: disposeBag)
        
        viewController.viewModel = viewModel
        
        return input.router.rx.push(
            viewController,
            isAnimated: true
        )
    }
}

// MARK: - Navigation

extension CharactersListCoordinator {
    func openDetail(component: CharacterComponentProtocol) -> Observable<Void> {
        let coordinator = CharacterDetailCoordinator.init(
            router: input.router,
            repository: input.repository,
            component: component,
            schedulers: input.schedulers)
        return coordinate(coordinator)
    }
}
