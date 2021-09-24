//
//  SeriesResponse.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation
import Realm
import RealmSwift

// MARK: - List Response
struct SeriesListResponse: Codable {
    let code: Int?
    let data: SeriesResponse?
}

// MARK: - Series Response
struct SeriesResponse: Codable {
    let results: [Serie?]?
    let offset: Int?
    let count: Int?
    let total: Int?
    let limit: Int?
}

// MARK: - Serie
class Serie: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var thumbnail: Thumbnail?

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Serie {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case thumbnail = "thumbnail"
        case desc = "description"
    }
}

