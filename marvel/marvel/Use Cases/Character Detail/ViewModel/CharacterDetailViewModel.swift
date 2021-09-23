//
//  CharacterDetailViewModel.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol CharacterDetailViewModelProtocol {
    var input: CharacterDetailViewModel.Input { get }
    var output: CharacterDetailViewModel.Output { get }
    
    /// Methods
    func setup()
}

// MARK: - I/O

extension CharacterDetailViewModel {

    struct Input {
        let component: CharacterComponentProtocol
        let repository: MarvelRepositoryProtocol
        let appSchedulers: AppSchedulers
    }
    
    struct Output {
        let state: PublishSubject<CharacterDetailState>
    }
}

// MARK: - Class

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    // MARK: - Protocol vars
    var input: Input
    var output: Output
    
    // MARK: - Private vars
    private let disposeBag: DisposeBag
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol,
         component: CharacterComponentProtocol,
         schedulers: AppSchedulers) {
        
        self.input = Input.init(
            component: component,
            repository: repository,
            appSchedulers: schedulers
        )
        self.output = Output.init(
            state: PublishSubject<CharacterDetailState>()
        )
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Load content
    
    func setup() {
        /// Loading
        output.state.onNext(.loading)
        fetchContent()
    }
    
    private func fetchContent(){
        input.repository
            .fetchComics(characterId: input.component.input.character.id)
            .subscribe(on: input.appSchedulers.background)
            .observe(on: input.appSchedulers.main)
            .subscribe(onNext: { [weak self] result in
                Log.debug("finish")
            }, onError: { [weak self] error in
                Log.debug(error.localizedDescription)
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
    
}
