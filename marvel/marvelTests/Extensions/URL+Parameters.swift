//
//  URL+Parameters.swift
//  marvelTests
//
//  Created by Michel Marques on 26/9/21.
//

import Foundation

extension URL {
    var components: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)
    }
}

extension Array where Iterator.Element == URLQueryItem {
    subscript(_ key: String) -> String? {
        return first(where: { $0.name == key })?.value
    }
}
