//
//  DetailComponentViewModelTest.swift
//  marvelTests
//
//  Created by Michel Marques on 24/9/21.
//

import XCTest
import RxTest
import RxSwift

@testable import marvel

class DetailComponentViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: DetailComponentProtocol!
    private var character: Character!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        /// Variables
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        /// Schedulers
        let schedulers = MarvelAppSchedulers.init(
            main: scheduler,
            background: scheduler
        )
        
        /// View Model
        self.character = MarvelRepositoryMock(
            appSchedulers: schedulers
        )
            .generateCharacters().first!
        let component = CharacterComponentViewModel.init(character: character)
        self.viewModel = DetailComponentViewModel.init(
            component: component
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        disposeBag = nil
        scheduler = nil
        viewModel = nil
        character = nil
    }

    func testInit(){
        XCTAssertNotNil(viewModel)
    }
    
    func testImageUrl() {
        XCTAssertEqual(
            character.thumbnail?.getImageUrl(),
            viewModel.output.imageUrl
        )
    }
    
    func testName() {
        XCTAssertEqual(
            character.name,
            viewModel.output.name
        )
    }
    
    func testDescription() {
        XCTAssertEqual(
            character.desc,
            viewModel.output.description
        )
    }
}
