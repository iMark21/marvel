//
//  APIConstants.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation

struct APIConstants {
    
    struct URL {
        static let baseUrl = "https://gateway.marvel.com"
    }
    
    struct Path {
        static let characters = "/v1/public/characters"
        static let comics = "/comics"
        static let series = "/series"
    }
    
    struct ParamKeys {
        static let apikey = "apikey"
        static let hash = "hash"
        static let ts = "ts"
        static let offset = "offset"
        static let limit = "limit"
    }
    
    struct ParamValues {
        static let pagerDefaultValue = 20
    }
    
    // MARK: API - KEYS
    
    struct Keys {
        static var filePath: String {
            // 1
            guard let filePath = Bundle.main.path(forResource: "Marvel-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Marvel-Info.plist'.")
            }
            return filePath
        }
        static var publicKey : String {
            get {
                let plist = NSDictionary(contentsOfFile: filePath)
                if let value = plist?.object(forKey: "PUBLIC_KEY") as? String,
                      value.isEmpty == false {
                    return value
                }
                fatalError("Couldn't find key 'PUBLIC_KEY' in 'Marvel-Info.plist'.")
            }
        }
        
        static var privateKey : String {
            get {
                let plist = NSDictionary(contentsOfFile: filePath)
                if let value = plist?.object(forKey: "PRIVATE_KEY") as? String,
                   value.isEmpty == false {
                    return value
                }
                fatalError("Couldn't find key 'PRIVATE_KEY' in 'Marvel-Info.plist'.")
            }
        }
    }
}
