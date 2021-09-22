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
    func fetchCharacters(paginator: MarvelPaginator) -> Observable<CharactersListResponse>
    func subscribeCharacters(paginator: MarvelPaginator) -> Observable<[Character]>
}

struct MarvelPaginator {
    var offset: Int
    let limit: Int
    
    mutating func nextPage() {
        self.offset = self.offset + limit
    }
}

class MarvelRepository: MarvelRepositoryProtocol {

    /// Public
    var apiClient: APIClientProtocol
    var databaseClient: DatabaseProtocol
    
    /// Private
    private let disposeBag: DisposeBag
    
    
    init(apiClient: APIClientProtocol = APIClient(),
         databaseClient: DatabaseProtocol = Database()) {
        
        self.apiClient = apiClient
        self.databaseClient = databaseClient
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Characters
    
    func fetchCharacters(paginator: MarvelPaginator) -> Observable<CharactersListResponse> {
        let request = CharactersRequest.init(
            offset: paginator.offset,
            limit: paginator.limit
        )
        return fetchNetworkRequest(request: request)
    }
    
    func subscribeCharacters<T: Codable & Object>(paginator: MarvelPaginator) -> Observable<[T]> {
        
        fetchCharacters(paginator: paginator)
            .map { response in
                if let objects = response.data?.results {
                    self.databaseClient.save(objects: objects)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        
        return subscribeDatabaseChanges(type: T.self)
            .flatMap { result -> Observable<[T]> in
                .just(result)
            }
    }
}

// MARK: - Local Access

extension MarvelRepository {
    
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
