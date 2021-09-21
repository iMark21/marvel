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
        var datasource: PublishSubject<[CharacterComponentProtocol]>
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
    var characters: [Character]
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol) {
        self.input = Input.init(
            repository: repository
        )
        self.output = Output.init(
            state: PublishSubject<CharactersListState>(),
            datasource: PublishSubject<[CharacterComponentProtocol]>()
        )
        self.characters = []
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
            .flatMap({ [weak self] characters -> Observable<[CharacterComponentProtocol]> in
                
                /// Check datasource is changed
                let isEqual = characters == self?.characters ?? []
                if isEqual { return .empty() }
                
                var components : [CharacterComponentProtocol] = []
                characters.forEach { character in
                    let component = CharacterComponentViewModel.init(
                        character: character
                    )
                    components.append(component)
                }
                self?.characters = characters
                return .just(components)
            })
            .subscribe(onNext: { [weak self] result in
                Log.debug("Actualiza")
                self?.output.datasource.onNext(result)
            }, onError: { [weak self] error in
                Log.debug(error.localizedDescription)
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
}
