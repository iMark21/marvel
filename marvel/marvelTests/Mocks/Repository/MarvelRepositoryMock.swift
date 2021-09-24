//
//  MarvelRepositoryMock.swift
//  marvelTests
//
//  Created by Michel Marques on 22/9/21.
//

import Foundation
import RxSwift
import RealmSwift
import Realm

@testable import marvel

class MarvelRepositoryMock: MarvelRepository {
    
    override func fetchCharacters<T: Codable & Object>(paginator: MarvelPager) -> Observable<[T]?>  {
        if let characters = generateCharacters() as? [T] {
            return .just(characters)
        }
        return .just(nil)
    }
    
    override func fetchComics<T>(characterId: Int) -> Observable<[T]> where T : Object, T : Decodable, T : Encodable {
        if let comics = generateComics() as? [T] {
            return .just(comics)
        }
        return .just([])
    }
    
    override func fetchSeries<T>(characterId: Int) -> Observable<[T]> where T : Object, T : Decodable, T : Encodable {
        if let series = generateSeries() as? [T] {
            return .just(series)
        }
        return .just([])
    }


    // MARK: - Private methods
    
    func generateCharacters() -> [Character] {
        do {
            let json = try JSONSerialization
                .jsonObject(
                    with: returnContentsOfJsonFile(named: "characters") ?? Data(),
                    options: []) as? [String : Any]
            
            guard let charactersData = json?["data"] as? [String: Any],
                let results = charactersData["results"] as? [Any] else {
                    return []
            }
            if let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted){
                if let characters = try? JSONDecoder.init().decode([Character].self, from: newData) {
                    return characters
                }
            }
        } catch { fatalError() }
            
        return []
    }
    
    func generateComics() -> [Comic] {
        do {
            let json = try JSONSerialization
                .jsonObject(
                    with: returnContentsOfJsonFile(named: "comics") ?? Data(),
                    options: []) as? [String : Any]
            
            guard let comicsData = json?["data"] as? [String: Any],
                let results = comicsData["results"] as? [Any] else {
                    return []
            }
            if let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted){
                if let comics = try? JSONDecoder.init().decode([Comic].self, from: newData) {
                    return comics
                }
            }
        } catch { fatalError() }
            
        return []
    }
    
    func generateSeries() -> [Serie] {
        do {
            let json = try JSONSerialization
                .jsonObject(
                    with: returnContentsOfJsonFile(named: "comics") ?? Data(),
                    options: []) as? [String : Any]
            
            guard let seriesData = json?["data"] as? [String: Any],
                let results = seriesData["results"] as? [Any] else {
                    return []
            }
            if let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted){
                if let series = try? JSONDecoder.init().decode([Serie].self, from: newData) {
                    return series
                }
            }
        } catch { fatalError() }
            
        return []
    }
}

// MARK: - File reader

extension MarvelRepositoryMock {
    func returnContentsOfJsonFile(named name: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        if let fileURL = testBundle.url(forResource: name, withExtension: "json") {
            do {
                return try String(contentsOf: fileURL, encoding: .utf8)
                    .data(using: .utf8)
            }
            catch {
                return nil
            }
        }
        return nil
    }
}

