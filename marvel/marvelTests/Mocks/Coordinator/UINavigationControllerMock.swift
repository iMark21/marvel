//
//  UINavigationControllerMock.swift
//  marvelTests
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation
import UIKit

@testable import marvel

class UINavigationControllerMock: UINavigationController {
    
    var viewControllerToPush: UIViewController!
    var viewControllerToPresent: UIViewController!
    var dismissVCCalled: Bool = false
    var popVCCalled: Bool = false

    
    override var presentedViewController: UIViewController? {
        get {
            return viewControllerToPresent
        }
        set {
            viewControllerToPresent = newValue
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllerToPush = viewController
    }
    

    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
        completion?()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissVCCalled = true
        completion?()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popVCCalled = true
        return viewControllers.first
    }
}
