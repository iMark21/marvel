//
//  Router.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

typealias NavigationBackClosure = (() -> Void)

protocol RouterProtocol: AnyObject {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
}

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}

class Router: NSObject, RouterProtocol {

    var navigationController: UINavigationController
    private var closures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        DispatchQueue.main.async {
            self.navigationController.delegate = self
        }
    }

    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else {
            return
        }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: isAnimated)
    }

    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }

    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(previousController)
    }
}

extension Reactive where Base: RouterProtocol {

    func push(_ drawable: Drawable, isAnimated: Bool) -> Observable<Void> {
        return Observable.create({ [weak base] observer -> Disposable in
            guard let base = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            // push Router as usual
            base.push(drawable, isAnimated: isAnimated, onNavigateBack: {
                observer.onNext(())
                observer.onCompleted()
            })

            return Disposables.create()
        })
    }
}
