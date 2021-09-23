//
//  CharacterComponentViewModelTest.swift
//  marvelTests
//
//  Created by Michel Marques on 23/9/21.
//

import XCTest

@testable import marvel

class CharacterComponentViewModelTest: XCTestCase {
    
    var componentViewModel: CharacterComponentProtocol!
    var character: Character!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.character = MarvelRepositoryMock().generateCharacters().first!
        self.componentViewModel = CharacterComponentViewModel.init(character: character)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.componentViewModel = nil
    }

    func testInit(){
        XCTAssertNotNil(componentViewModel)
    }
    
    func testUrl() {
        XCTAssertEqual(
            "\(character.thumbnail?.url ?? "")" + "." + "\(character.thumbnail?.mimeType ?? "")",
            componentViewModel.output.imageUrl?.absoluteString
        )
    }

    func testName() {
        XCTAssertEqual(
            character.name,
            componentViewModel.output.name
        )
    }

}
