//
//  Database.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

protocol DatabaseProtocol {
    func save<T: Object & Codable>(objects: [T?]?)
    func get<T: Object & Codable>(type: T.Type) -> Observable<[T]>
    func observe<T: Object>(type: T.Type) -> Observable<[T]>
}

class Database: DatabaseProtocol {
    
    private let disposeBag: DisposeBag
    private let appSchedulers: MarvelAppSchedulers
    
    init() {
        self.disposeBag = DisposeBag()
        self.appSchedulers = MarvelAppSchedulers()
    }
    
    func get<T: Object>(type: T.Type) -> Observable<[T]> {
        do {
            let realm = try Realm()
            let objs = realm.objects(type).toArray()
            return .just(objs)
        } catch _ {
            return .just([])
        }
    }
    
    func save<T: Object>(objects: [T?]?) {
        if let realm = try? Realm(),
           let objects = objects {

            let result = objects.compactMap { $0 }

            Observable.from(result)
                .subscribe(realm.rx.add(update: .modified))
                .disposed(by: disposeBag)
        }
    }
    
    func observe<T: Object>(type: T.Type) -> Observable<[T]> {
        let realm = try! Realm()
        let result = realm.objects(type.self)
        
        Log.debug("Object \(T.self) (\(result.count) count) list is available")
        
        return Observable.changeset(from: result)
            .flatMap({ results, changes -> Observable<[T]> in
                if let changes = changes {
                    // it's an update
                    Log.debug("deleted: \(changes.deleted)")
                    Log.debug("inserted: \(changes.inserted)")
                    Log.debug("updated: \(changes.updated)")
                } else {
                    // it's the initial data
                    Log.debug(results)
                }
                
                return .just(results.toArray())
            })
    }
}
