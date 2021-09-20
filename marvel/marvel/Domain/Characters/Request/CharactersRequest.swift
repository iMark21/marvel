//
//  CharactersRequest.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation

final class CharactersRequest: APIRequest {

    var body: Data?
    var method: RequestType
    var path: String
    var parameters: [String : String]

    init() {
        self.method = .GET
        self.path = "\(APIConstants.Path.characters)"
        self.parameters = [:]
    }
}
