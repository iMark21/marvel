//
//  MediaComponentViewModelTests.swift
//  marvelTests
//
//  Created by Michel Marques on 24/9/21.
//

import XCTest
import RxTest
import RxSwift

@testable import marvel

class MediaComponentViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: MediaComponentProtocol!
    private var comic: Any!
    
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
        self.comic = MarvelRepositoryMock(
            appSchedulers: schedulers
        )
        .generateComics().first
        self.viewModel = MediaComponentViewModel.init(media: comic!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        disposeBag = nil
        scheduler = nil
        viewModel = nil
        comic = nil
    }

    func testInit(){
        XCTAssertNotNil(viewModel)
    }
    
    func testIsComic() {
        XCTAssert(comic! is Comic)
    }
    
    func testImageUrl() {
        XCTAssertEqual(
            (comic as! Comic).thumbnail?.getImageUrl(),
            viewModel.output?.imageUrl
        )
    }
    
    func testName() {
        XCTAssertEqual(
            (comic as! Comic).title!,
            viewModel.output?.title
        )
    }
}
