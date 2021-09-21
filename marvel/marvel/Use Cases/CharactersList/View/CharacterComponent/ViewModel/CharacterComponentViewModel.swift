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
    
    struct Constants {
        static let cellIdentifier = "CharacterComponent"
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
            imageUrl: URL(
                string: (
                    (character.thumbnail?.url ?? "") +
                        "." +
                        (character.thumbnail?.mimeType ?? "")
                )
            ),
            name: character.name ?? "-"
        )
    }
    
}
