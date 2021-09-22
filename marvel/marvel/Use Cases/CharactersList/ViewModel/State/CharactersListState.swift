//
//  CharactersListState.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

enum CharactersListState {
    case loading
    case loaded
    case nextPage
    case error(_ error: Error)
}
