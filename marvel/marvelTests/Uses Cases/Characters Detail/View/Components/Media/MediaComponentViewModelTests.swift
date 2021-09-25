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
    private var media: Any!
    
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
        self.media = MarvelRepositoryMock(
            appSchedulers: schedulers
        )
        .generateComics().first
        self.viewModel = MediaComponentViewModel.init(media: media!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        disposeBag = nil
        scheduler = nil
        viewModel = nil
        media = nil
    }

    func testInit(){
        XCTAssertNotNil(viewModel)
    }
    
    func testIsComic() {
        XCTAssert(media is Comic)
    }
    
    func testImageUrl() {
        XCTAssertEqual(
            (media as! Comic).thumbnail?.getImageUrl(),
            viewModel.output?.imageUrl
        )
    }
    
    func testName() {
        XCTAssertEqual(
            (media as! Comic).title,
            viewModel.output?.title
        )
    }
}
