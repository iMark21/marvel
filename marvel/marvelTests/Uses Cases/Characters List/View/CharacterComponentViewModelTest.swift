//
//  CharacterComponentViewModelTest.swift
//  marvelTests
//
//  Created by Michel Marques on 23/9/21.
//

import XCTest
import RxTest

@testable import marvel

class CharacterComponentViewModelTest: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var componentViewModel: CharacterComponentProtocol!
    private var character: Character!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.scheduler = TestScheduler(initialClock: 0)

        /// Schedulers
        let schedulers = MarvelAppSchedulers.init(
            main: scheduler,
            background: scheduler
        )
        
        self.character = MarvelRepositoryMock(
            appSchedulers: schedulers
        )
            .generateCharacters().first!
        self.componentViewModel = CharacterComponentViewModel.init(character: character)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.componentViewModel = nil
        self.scheduler = nil
        
        try super.tearDownWithError()
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
