//
//  APIConstants.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation

struct APIConstants {
    
    struct Keys {
        static let publicKey = "d66fc31f297d190217a31ee824e96911"
        static let privateKey = "206dcf5f94cfee8a69d52e034e0e0ea99dbf715d"
    }
    
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
}
