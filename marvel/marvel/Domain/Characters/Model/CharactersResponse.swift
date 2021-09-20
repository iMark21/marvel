//
//  CharactersResponse.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import Realm
import RealmSwift

struct CharactersListResponse: Codable {
    let code: Int?
    let data: CharactersResponse?
}

struct CharactersResponse: Codable {
    let results: [Character?]?
    let offset: Int?
    let count: Int?
    let total: Int?
    let limit: Int?
}

class Character: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}

