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
    private var paginator: MarvelPager
    private var characters: [Character]
    private var dataSource: [ComponentsDataSource]
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol,
         schedulers: AppSchedulers = MarvelAppSchedulers()) {
        
        self.input = Input.init(
            repository: repository
        )
        self.output = Output.init(
            state: PublishSubject<CharactersListState>(),
            dataSource: BehaviorRelay<[ComponentsDataSource]>(value: [])
        )
        self.paginator = MarvelPager.init(
            offset: 0,
            limit: 20
        )
        self.characters = []
        self.dataSource = [ComponentsDataSource.init(
                            uniqueId: UUID().uuidString,
                            header: "",
                            items: [])]
        self.disposeBag = DisposeBag()
        self.appSchedulers = schedulers
    }
    
    // MARK: - Load content
    
    func setup() {
        /// Loading
        output.state.onNext(.loading)
        fetchContent()
    }
    
    // MARK: - Paginator
    
    func loadNextPage() {
        /// Load next page
        output.state.onNext(.nextPage)
        paginator.nextPage()
        /// Request
        fetchContent()
    }
    
    private func fetchContent(){
        input.repository
            .fetchCharacters(paginator: paginator)
            .subscribe(on: appSchedulers.background)
            .observe(on: appSchedulers.main)
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
        if paginator.isFirstPage {
            dataSource[0].items = []
        }
        
        /// Generate components
        var components : [CharacterComponentViewModel] = []
        newCharacters.forEach { character in
            
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
