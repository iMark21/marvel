//
//  MarvelRepository.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

protocol MarvelRepositoryProtocol {
    var apiClient: APIClientProtocol { get }
    var databaseClient: DatabaseProtocol { get }
    
    /// Specialties
    func fetchCharacters() -> Observable<CharactersListResponse>
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
    
    func fetchCharacters<T: Codable>() -> Observable<T> {
        let request = CharactersRequest.init()
        return fetchNetworkRequest(request: request)
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
