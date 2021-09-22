//
//  CharactersListViewModel.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol CharactersListViewModelProtocol {
    var input: CharactersListViewModel.Input { get }
    var output: CharactersListViewModel.Output { get }
    
    /// Methods
    func setup()
    func loadNextPage()
}

// MARK: - I/O

extension CharactersListViewModel {

    struct Input {
        let repository: MarvelRepositoryProtocol
    }
    
    struct Output {
        let state: PublishSubject<CharactersListState>
        let dataSource: BehaviorRelay<[ComponentsDataSource]>
    }
}

// MARK: - Class

class CharactersListViewModel: CharactersListViewModelProtocol {
    
    // MARK: - Protocol vars
    var input: Input
    var output: Output
    
    // MARK: - Private vars
    private let disposeBag: DisposeBag
    private let appSchedulers: AppSchedulers
    private var paginator: MarvelPaginator
    private var characters: [Character]
    private var dataSource: [ComponentsDataSource]
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol) {
        self.input = Input.init(
            repository: repository
        )
        self.output = Output.init(
            state: PublishSubject<CharactersListState>(),
            dataSource: BehaviorRelay<[ComponentsDataSource]>(value: [])
        )
        self.paginator = MarvelPaginator.init(
            offset: 0,
            limit: 20
        )
        self.characters = []
        self.dataSource = [ComponentsDataSource.init(
                            uniqueId: UUID().uuidString,
                            header: "",
                            items: [])]
        self.disposeBag = DisposeBag()
        self.appSchedulers = MarvelAppSchedulers()
    }
    
    // MARK: - Load content
    
    func setup() {
        /// Loading
        output.state.onNext(.loading)
        
        input.repository
            .subscribeCharacters(paginator: paginator)
            .subscribe(onNext: { [weak self] result in
                guard let weakSelf = self else {return}
                Log.debug("Updated database")
                weakSelf.appendCharacters(result)
            }, onError: { [weak self] error in
                Log.debug(error.localizedDescription)
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Paginator
    
    func loadNextPage() {
        /// Load next page
        output.state.onNext(.nextPage)
        paginator.nextPage()
                
        input.repository
            .fetchCharacters(paginator: paginator)
            .subscribe(on: appSchedulers.background)
            .observe(on: appSchedulers.main)
            .flatMap({ response -> Observable<[Character]> in
                guard let characters = response.data?.results else {
                    return .just([])
                }
                return .just(characters.compactMap{$0})
            })
            .subscribe(onNext: { [weak self] result in
                self?.appendCharacters(result)
            }, onError: { [weak self] error in
                Log.debug(error.localizedDescription)
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
}

// MARK: - Generate Data Source

extension CharactersListViewModel {
    func appendCharacters(_ newCharacters: [Character]) {
        
        /// Check and update new elements avoiding duplicates
        var elements: [Character] = []
        newCharacters.forEach { newCharacter in
            if let row = characters.firstIndex(where: {$0.id == newCharacter.id}) {
                   characters[row] = newCharacter
            } else {
                elements.append(newCharacter)
            }
        }
        characters.append(contentsOf: elements)
        
        /// Generate components
        var components : [CharacterComponentViewModel] = []
        elements.forEach { character in
            
            let component = CharacterComponentViewModel.init(
                character: character
            )
            components.append(component)
        }
        dataSource[0].items.append(contentsOf: components)
        
        output.dataSource.accept(dataSource)
        output.state.onNext(.loaded)
    }
}
