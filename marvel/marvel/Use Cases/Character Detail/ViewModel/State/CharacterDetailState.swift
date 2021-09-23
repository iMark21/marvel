//
//  CharacterDetailState.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
enum CharacterDetailState: Equatable {
    
    case loading
    case loaded
    case error(_ error: Error)
    
    static func == (lhs: CharacterDetailState, rhs: CharacterDetailState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

