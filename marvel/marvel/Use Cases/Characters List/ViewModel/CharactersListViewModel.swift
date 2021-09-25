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
        let appSchedulers: AppSchedulers
    }
    
    struct Output {
        let action: PublishSubject<CharactersListAction>
        let dataSource: BehaviorRelay<[ComponentsDataSource]>
        let state: PublishSubject<CharactersListState>
    }
}

// MARK: - Class

class CharactersListViewModel: CharactersListViewModelProtocol {
    
    // MARK: - Protocol vars
    var input: Input
    var output: Output
    
    // MARK: - Private vars
    private let disposeBag: DisposeBag
    private var paginator: MarvelPager
    private var dataSource: [ComponentsDataSource]
    
    // MARK: - Init
    init(repository: MarvelRepositoryProtocol,
         schedulers: AppSchedulers) {
        
        self.input = Input.init(
            repository: repository,
            appSchedulers: schedulers
        )
        self.output = Output.init(
            action: PublishSubject<CharactersListAction>(),
            dataSource: BehaviorRelay<[ComponentsDataSource]>(value: []),
            state: PublishSubject<CharactersListState>()
        )
        self.paginator = MarvelPager.init(
            offset: 0,
            limit: 20
        )
        self.dataSource = [
            ComponentsDataSource.init(
                uniqueId: UUID().uuidString,
                header: "",
                items: [])
        ]
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
            .fetchCharacters(paginator: paginator)
            .subscribe(on: input.appSchedulers.background)
            .observe(on: input.appSchedulers.main)
            .subscribe(onNext: { [weak self] result in
                guard let result = result else { return }
                self?.appendCharacters(result)
            }, onError: { [weak self] error in
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Paginator
    func loadNextPage() {
        /// Load next page
        output.state.onNext(.nextPage)
        paginator.nextPage()
        /// Request
        fetchContent()
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
