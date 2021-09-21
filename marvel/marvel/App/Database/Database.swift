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
    func observe<T: Object>(type: T.Type) -> Observable<[T]>
}

class Database: DatabaseProtocol {
    
    private let disposeBag: DisposeBag
    private let appSchedulers: MarvelAppSchedulers
    
    init() {
        self.disposeBag = DisposeBag()
        self.appSchedulers = MarvelAppSchedulers()
    }
    
    func observe<T: Object>(type: T.Type) -> Observable<[T]> {
        let realm = try! Realm()
        let result = realm.objects(type.self)
        
        Log.debug("Object \(T.self) (\(result.count) count) list is available")
        
        return Observable.array(from: result)
            .observe(on: appSchedulers.background)
    }
    
    func save<T: Object>(objects: [T?]?) {
        if let realm = try? Realm(),
           let objects = objects {

            let result = objects.compactMap { $0 }

            Observable.from(result)
                .subscribe(on: appSchedulers.background)
                .observe(on: appSchedulers.main)
                .subscribe(realm.rx.add())
                .disposed(by: disposeBag)
        }
    }
    
}
