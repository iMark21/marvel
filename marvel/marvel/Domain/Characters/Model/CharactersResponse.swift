//
//  CharactersResponse.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import Realm
import RealmSwift

// MARK: - List Response
struct CharactersListResponse: Codable {
    let code: Int?
    let data: CharactersResponse?
}

// MARK: - Characters Response
struct CharactersResponse: Codable {
    let results: [Character?]?
    let offset: Int?
    let count: Int?
    let total: Int?
    let limit: Int?
}

// MARK: - Character
class Character: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String?
    @objc dynamic var thumbnail: Thumbnail?

    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Character
class Thumbnail: Object, Codable {
    @objc dynamic var url: String?
    @objc dynamic var mimeType: String?
}

extension Thumbnail {
    enum CodingKeys: String, CodingKey {
        case url = "path"
        case mimeType = "extension"
    }
}


