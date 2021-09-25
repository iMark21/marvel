//
//  ComicsRequest.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation

final class ComicsRequest: APIRequest {

    var body: Data?
    var method: RequestType
    var path: String
    var parameters: [String : String]

    init(characterId: Int) {
        self.method = .GET
        self.path = "\(APIConstants.Path.characters)" +
            "/\(characterId)" +
            "\(APIConstants.Path.comics)"
        self.parameters = [:]
    }
}
