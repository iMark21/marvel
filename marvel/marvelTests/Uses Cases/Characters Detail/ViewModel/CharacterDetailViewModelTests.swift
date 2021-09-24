//
//  CharacterDetailViewModelTests.swift
//  marvelTests
//
//  Created by Michel Marques on 24/9/21.
//

import XCTest
import RxTest
import RxSwift

@testable import marvel

class CharacterDetailViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: CharacterDetailViewModelProtocol!
    private var repository: MarvelRepositoryProtocol!
    
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
        self.repository = MarvelRepositoryMock(appSchedulers: schedulers)

        
        /// View Model
        let character = MarvelRepositoryMock(
            appSchedulers: schedulers
        )
            .generateCharacters().first!
        let component = CharacterComponentViewModel.init(character: character)
        self.viewModel = CharacterDetailViewModel.init(
            repository: repository,
            component: component,
            schedulers: schedulers
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        disposeBag = nil
        scheduler = nil
        viewModel = nil
        repository = nil
    }

    
    func testDataSource() {

        /// Given
        let dataSource = scheduler.createObserver([MultipleSectionModel].self)

        viewModel
            .output
            .dataSource
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        /// When
        viewModel.setup()
        scheduler.start()

        /// Then
        let firstIteration = (dataSource.events[0].value).element!
        XCTAssertEqual(firstIteration.count, 0)
        
        if let sections = (dataSource.events[1].value).element {
            XCTAssert(sections.count == 1) /// Header
        } else {
            XCTFail("Header not modeled")
        }
        
        if let sections = (dataSource.events[2].value).element {
            XCTAssert(sections.count == 2) /// Comics and Series loaded
        } else {
            XCTFail("Media not modeled")
        }
    }
}
