//
//  CharacterDetailState.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
enum CharacterDetailState: Equatable {
    
    case error(_ error: Error)
    
    static func == (lhs: CharacterDetailState, rhs: CharacterDetailState) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        }
    }
}

