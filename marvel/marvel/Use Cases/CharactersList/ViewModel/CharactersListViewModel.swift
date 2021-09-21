//
//  CharactersListViewModel.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

// MARK: - Protocol

protocol CharactersListViewModelProtocol {
    var input: CharactersListViewModel.Input { get }
    var output: CharactersListViewModel.Output { get }
    
    /// Methods
    func setup()
}

// MARK: - I/O

extension CharactersListViewModel {

    struct Input {
        let repository: MarvelRepositoryProtocol
    }
    
    struct Output {
        let state: PublishSubject<CharactersListState>
    }
}

// MARK: - Class

class CharactersListViewModel: CharactersListViewModelProtocol {
    
    // MARK: - Protocol vars
    var input: Input
    var output: Output
    
    // MARK: - Private vars
    let disposeBag: DisposeBag
    let appSchedulers: AppSchedulers
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol) {
        self.input = Input.init(
            repository: repository
        )
        self.output = Output.init(
            state: PublishSubject<CharactersListState>()
        )
        self.disposeBag = DisposeBag()
        self.appSchedulers = MarvelAppSchedulers()
    }
    
    // MARK: - Load content
    func setup() {
        /// Loading
        output.state.onNext(.loading)
        
        let repository: MarvelRepositoryProtocol = MarvelRepository.init()
        repository
            .subscribeCharacters()
            .subscribe(onNext: { [weak self] result in
                self?.output.state.onNext(.loaded([]))
            }, onError: { [weak self] error in
                Log.debug(error.localizedDescription)
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func save(from response: CharactersListResponse) {
        
    }
}
