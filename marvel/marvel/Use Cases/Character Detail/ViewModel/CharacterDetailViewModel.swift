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
        let dataSource: BehaviorRelay<[MultipleSectionModel]>
    }
}

// MARK: - Class

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    // MARK: - Protocol vars
    var input: Input
    var output: Output
    
    // MARK: - Private vars
    private let disposeBag: DisposeBag
    private var dataSource: [MultipleSectionModel]
    
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
            state: PublishSubject<CharacterDetailState>(),
            dataSource: BehaviorRelay<[MultipleSectionModel]>(value: []
            )
        )
        self.dataSource = []
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Load content
    
    func setup() {
        let component = DetailComponentViewModel.init(component: input.component)
        self.dataSource = [
            .HeaderSection(title: "", items: [
                .HeaderSectionItem(component: component)
                ]
            )
        ]
        self.output.dataSource.accept(dataSource)
        fetchContent()
    }
    
    private func fetchContent(){
        loadMedia()
    }
}

extension CharacterDetailViewModel {
    /// Comics
    func loadMedia() {
        
        Observable<[AnyObject]>.concat(
            input.repository
                .fetchComics(characterId: input.component.input.character.id)
                .map{ $0 as [AnyObject] },
            input.repository
                .fetchSeries(characterId: input.component.input.character.id)
                .map{ $0 as [AnyObject] }
            )
            .subscribe(on: input.appSchedulers.background)
            .observe(on: input.appSchedulers.main)
            .flatMap({ [weak self] result -> Observable<MultipleSectionModel?> in
                guard let weakSelf = self,
                      result.count > 0 else { return .just(nil) }
                
                var sectionTitle = ""
                if let _ = result as? [Comic] { sectionTitle = "Comics" }
                if let _ = result as? [Serie] { sectionTitle = "Series" }
                
                let section = MultipleSectionModel.MediaSection(
                    title: sectionTitle,
                    items: [
                        .MediaSectionItem(
                            components: weakSelf.buildMediaComponentsFor(result)
                        )
                    ]
                )
                return .just(section)
            })
            .subscribe(onNext: { [weak self] sectionModel in
                guard let weakSelf = self,
                      let sectionModel = sectionModel
                else { return }

                weakSelf.dataSource.append(sectionModel)
                weakSelf.output.dataSource.accept(weakSelf.dataSource)
            }, onError: { [weak self] error in
                self?.output.state.onNext(.error(error))
            }).disposed(by: disposeBag)
    }
    
    
    func buildMediaComponentsFor(_ medias: [Any]) -> [MediaComponentProtocol] {
        var components: [MediaComponentProtocol] = []
        medias.forEach { media in
            let component = MediaComponentViewModel.init(media: media)
            components.append(component)
        }
        return components
    }
    
}
