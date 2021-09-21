//
//  CharacterComponentViewModel.swift
//  marvel
//
//  Created by Michel Marques on 21/9/21.
//

import Foundation

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
        let name: String
    }
}

// MARK: - CharacterComponentViewModel
class CharacterComponentViewModel: CharacterComponentProtocol {
    
    /// Protocol
    var input: Input
    var output: Output
    
    init(character: Character) {
        self.input = Input.init(character: character)
        self.output = Output.init(
            imageUrl: URL(string: character.thumbnail?.url ?? ""),
            name: character.name ?? "-"
        )
    }
    
}
