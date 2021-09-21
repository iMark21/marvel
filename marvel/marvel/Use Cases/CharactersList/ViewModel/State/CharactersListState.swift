//
//  CharactersListState.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation

enum CharactersListState {
    case loading
    case loaded
    case error(_ error: Error)
}
