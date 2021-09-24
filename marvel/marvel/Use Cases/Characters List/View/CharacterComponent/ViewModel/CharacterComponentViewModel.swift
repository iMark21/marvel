//
//  CharacterComponentViewModel.swift
//  marvel
//
//  Created by Michel Marques on 21/9/21.
//

import Foundation
import RxDataSources

// MARK: - Protocol
protocol CharacterComponentProtocol {
    var input: CharacterComponentViewModel.Input { get }
    var output: CharacterComponentViewModel.Output { get }
}

// MARK: - I/O
extension CharacterComponentViewModel {
    struct Input {
        let character: Character
    }
    
    struct Output {
        let imageUrl: URL?
        let name: String?
        let description: String?
    }
}

// MARK: - CharacterComponentViewModel
class CharacterComponentViewModel: CharacterComponentProtocol {
    
    /// Protocol
    var input: Input
    var output: Output
    
    init(character: Character) {
        self.input = Input.init(
            character: character
        )
        self.output = Output.init(
            imageUrl: character.thumbnail?.getImageUrl(),
            name: character.name,
            description: character.desc
        )
    }
}

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
