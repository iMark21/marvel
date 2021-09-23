//
//  CharactersListCoordinatorTests.swift
//  marvelTests
//
//  Created by Michel Marques on 23/9/21.
//

import XCTest
import RxTest
import RxSwift

@testable import marvel

class CharactersListCoordinatorTests: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var navigationController: UINavigationControllerMock!
    private var router: Router!
    private var coordinator: CharactersListCoordinator!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        /// Variables
        try super.setUpWithError()

        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.navigationController = UINavigationControllerMock()
        self.router = Router(navigationController: navigationController)
        
        /// Schedulers
        let schedulers = MarvelAppSchedulers.init(
            main: scheduler,
            background: scheduler
        )
        
        /// Coordinator
        self.coordinator = CharactersListCoordinator.init(
            router: router,
            scheduler: schedulers
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()

        self.scheduler = nil
        self.disposeBag = nil
        self.navigationController = nil
        self.router = nil
        self.coordinator = nil
    }

    func testStart() {
        /// Given
        let start = scheduler.createObserver(Void.self)
        
        /// When
        let coordinator = CharactersListCoordinator.init(router: router)
        coordinator.start()
            .bind(to: start)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        /// Then
        let viewControllerToPresent = navigationController.viewControllerToPush as? CharactersListViewController
        XCTAssertNotNil(viewControllerToPresent)

    }
    
    func testCoordinate() {
        /// Given
        let coordinate = scheduler.createObserver(Void.self)
        
        /// When
        coordinator.coordinate(coordinator)
            .bind(to: coordinate)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        /// Then
        XCTAssert(coordinator.childCoordinators.contains{ $0 is CharactersListCoordinator})
    }

}
