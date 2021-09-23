//
//  ComicsResponse.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
import Realm
import RealmSwift

// MARK: - List Response
struct ComicsListResponse: Codable {
    let code: Int?
    let data: ComicsResponse?
}

// MARK: - Comics Response
struct ComicsResponse: Codable {
    let results: [Character?]?
    let offset: Int?
    let count: Int?
    let total: Int?
    let limit: Int?
}

// MARK: - Comic
class Comic: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String?
    @objc dynamic var desc: String?
    @objc dynamic var thumbnail: Thumbnail?

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Comic {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case thumbnail = "thumbnail"
        case desc = "description"
    }
}
