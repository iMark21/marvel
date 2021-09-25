//
//  CharactersListDataSource.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation
import RxDataSources

struct ComponentsDataSource {
    var uniqueId: String
    var header: String
    var items: [CharacterComponentViewModel]
}

extension ComponentsDataSource: AnimatableSectionModelType {

    typealias Item = CharacterComponentViewModel
    typealias Identity = String
    
    var identity: Identity { return uniqueId }

    init(original: ComponentsDataSource, items: [CharacterComponentViewModel]) {
        self = original
        self.items = items
    }
}

extension CharacterComponentViewModel: IdentifiableType, Equatable {
    typealias Identity = Int

    var identity: Identity { return input.character.id }

    static func == (lhs: CharacterComponentViewModel, rhs: CharacterComponentViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
