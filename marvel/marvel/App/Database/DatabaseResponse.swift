//
//  DatabaseResponse.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import Realm
import RealmSwift

class DatabaseResponse: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var data: Data?

    override static func primaryKey() -> String? {
        return "id"
    }
}
