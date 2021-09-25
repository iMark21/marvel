//
//  APIClient.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift
import RealmSwift

enum APIError: Error {
    case unknownUrl
}

protocol APIClientProtocol {
    var baseUrl: URL? {get}
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T>
}

class APIClient: APIClientProtocol {

    var baseUrl: URL?
    private let disposeBag: DisposeBag
    private let database: DatabaseProtocol

    init(baseURL: URL? = URL.init(string: APIConstants.URL.baseUrl),
         database: DatabaseProtocol = Database()) {
        
        self.baseUrl = baseURL
        self.database = database
        self.disposeBag = DisposeBag()
    }

    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let url = self.baseUrl else {
                observer.onError(APIError.unknownUrl)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let request = apiRequest.request(with: url)
            
            /// Log request
            Log.request(request)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    if let error = error {
                        //Log errors on fabric/firebase
                        observer.onError(error)
                    }
                    return
                }
                
                /// Log response
                Log.responseData(data, response: httpUrlResponse, error: error)

                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
