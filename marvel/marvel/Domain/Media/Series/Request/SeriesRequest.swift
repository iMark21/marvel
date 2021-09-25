//
//  SeriesRequest.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation

final class SeriesRequest: APIRequest {

    var body: Data?
    var method: RequestType
    var path: String
    var parameters: [String : String]

    init(characterId: Int) {
        self.method = .GET
        self.path = "\(APIConstants.Path.characters)" +
            "/\(characterId)" +
            "\(APIConstants.Path.series)"
        self.parameters = [:]
    }
}
