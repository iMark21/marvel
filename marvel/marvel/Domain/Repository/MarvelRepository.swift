//
//  MarvelRepository.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift
import Realm
import RealmSwift

protocol MarvelRepositoryProtocol {
    var apiClient: APIClientProtocol { get }
    var databaseClient: DatabaseProtocol { get }
    
    /// Characters
    func fetchCharacters(paginator: MarvelPager) -> Observable<[Character]>
    
    /// Comics
    func fetchComics(characterId: String) -> Observable<[Comic]>
}

struct MarvelPager {
    var offset: Int
    let limit: Int
    var isFirstPage: Bool {
        return offset == 0
    }
    
    mutating func nextPage() {
        self.offset = self.offset + limit
    }
}

class MarvelRepository: MarvelRepositoryProtocol {

    /// Public
    var apiClient: APIClientProtocol
    var databaseClient: DatabaseProtocol
    
    /// Private
    private let appSchedulers: AppSchedulers
    private let disposeBag: DisposeBag
    
    
    init(apiClient: APIClientProtocol = APIClient(),
         databaseClient: DatabaseProtocol = Database(),
         appSchedulers: AppSchedulers) {
        
        self.apiClient = apiClient
        self.databaseClient = databaseClient
        self.appSchedulers = appSchedulers
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Characters
    
    func fetchCharacters<T: Codable & Object>(paginator: MarvelPager) -> Observable<[T]> {
        let request = CharactersRequest.init(
            offset: paginator.offset,
            limit: paginator.limit
        )
        
        let observeResponse: Observable<CharactersListResponse> =
            fetchNetworkRequest(request: request)
        let fetchRequest = observeResponse
            .flatMap { response -> Observable<[T]> in
                if let result = response.data?.results?
                    .compactMap({$0}) as? [T] {
                    return .just(result)
                }
                return .just([])
        }
        
        /// Try to load DB - Network
        if paginator.isFirstPage {
            return Observable<[T]>.concat(
                fetchLocal(type: T.self),
                fetchRequest
                    .observe(on: appSchedulers.main)
                    .flatMap { result -> Observable<[T]> in
                        self.saveObjects(objects: result)
                        return .just(result)
                }
            )
        } else {
            /// Load next page
            return fetchRequest
        }
        
    }
    
    // MARK: - Comics
    
    func fetchComics(characterId: String) -> Observable<[Comic]> {
        let request = ComicsRequest.init(characterId: characterId)
        return fetchNetworkRequest(request: request)
    }
    
}

// MARK: - Local Access

extension MarvelRepository {
    
    func fetchLocal<T: Codable & Object>(type: T.Type) -> Observable<[T]> {
        return self.databaseClient.get(type: type)
    }
    
    func saveObjects<T: Codable & Object>(objects: [T]) {
        self.databaseClient.save(objects: objects)
    }
    
    func subscribeDatabaseChanges<T: Codable & Object>(type: T.Type) -> Observable<[T]> {
        return self.databaseClient.observe(type: type)
    }
}

// MARK: - Network Access

extension MarvelRepository {
    
    func fetchNetworkRequest<T: Codable>(request: APIRequest) -> Observable<T> {
        
        return self.apiClient
            .send(apiRequest: request)
            .retry(3)
            .flatMap { response -> Observable<T> in
                .just(response)
            }
    }
}
