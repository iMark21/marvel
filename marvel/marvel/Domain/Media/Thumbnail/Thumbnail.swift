//
//  Thumbnail.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation
import UIKit
import Realm
import RealmSwift

// MARK: - Thumbnail
class Thumbnail: Object, Codable {
    @objc dynamic var url: String?
    @objc dynamic var mimeType: String?
}

extension Thumbnail {
    enum CodingKeys: String, CodingKey {
        case url = "path"
        case mimeType = "extension"
    }
    
    func getImageUrl() -> URL? {
        return URL(
            string: (
                (self.url ?? "") +
                    "." +
                    (self.mimeType ?? "")
            )
        )
    }
}
