//
//  Coordinator.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start() -> Observable<Void>
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator?) {
        Log.debug("Bye coordinator list: \(String(describing: childCoordinators))")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        Log.debug("Bye coordinator list: \(String(describing: childCoordinators))")
    }
}

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    let scheduler: ImmediateSchedulerType
    
    init(childCoordinators: [Coordinator] = [], scheduler: ImmediateSchedulerType = MainScheduler.instance) {
        self.childCoordinators = childCoordinators
        self.scheduler = scheduler
    }

    func start() -> Observable<Void> {
        fatalError("Start method should be implemented in inherited class.")
    }

    func coordinate(_ coordinator: Coordinator) -> Observable<Void> {
        self.store(coordinator: coordinator)
        Log.debug("Hello coordinator: \(String(describing: coordinator))")

        return coordinator
            .start()
            .observe(on: scheduler)
            .do(onNext: { [weak self, weak coordinator] _ in
                Log.debug("Bye coordinator: \(String(describing: coordinator))")
                self?.free(coordinator: coordinator)
            })
    }
}
