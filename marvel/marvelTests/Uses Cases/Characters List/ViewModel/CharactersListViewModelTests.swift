//
//  CharactersListViewModelTests.swift
//  marvelTests
//
//  Created by Michel Marques on 22/9/21.
//

import XCTest
import RxTest
import RxSwift

@testable import marvel

class CharactersListViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: CharactersListViewModelProtocol!
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
        self.viewModel = CharactersListViewModel.init(
            repository: repository,
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

    func testSetup() {

        /// Given
        let state = scheduler.createObserver(CharactersListState.self)
        
        viewModel
            .output
            .state
            .bind(to: state)
            .disposed(by: disposeBag)
        
        /// When
        viewModel.setup()
        scheduler.start()
        
        /// Then
        let loadingState = (state.events[0].value).element!
        XCTAssertEqual(loadingState, CharactersListState.loading)
        
        let loadedState = (state.events[1].value).element!
        XCTAssertEqual(loadedState, CharactersListState.loaded)
    }
    
    func testNextPage() {

        /// Given
        let state = scheduler.createObserver(CharactersListState.self)
        
        viewModel
            .output
            .state
            .bind(to: state)
            .disposed(by: disposeBag)
        
        /// When
        viewModel.loadNextPage()
        scheduler.start()
        
        /// Then
        let nextPageState = (state.events[0].value).element!
        XCTAssertEqual(nextPageState, CharactersListState.nextPage)
        
        let loadedState = (state.events[1].value).element!
        XCTAssertEqual(loadedState, CharactersListState.loaded)
    }
    
    func testDataSource() {

        /// Given
        let dataSource = scheduler.createObserver([ComponentsDataSource].self)

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
            sections.forEach { section in
                XCTAssert(section.items.count > 0)
            }
        } else {
            XCTFail("Items not modeled")
        }
    }
}
