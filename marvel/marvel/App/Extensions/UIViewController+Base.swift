//
//  UIViewController+Base.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation
import UIKit

protocol Baseable {
    
}

extension UIViewController {
    
    // MARK: - Error alert
    
    func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Oops!",
            message: error.localizedDescription,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Add or remove views
    
    func add(_ child: UIViewController) {
            addChild(child)
            view.addSubview(child.view)
            child.didMove(toParent: self)
        }

        func remove() {
            // Just to be safe, we check that this view controller
            // is actually added to a parent before removing it.
            guard parent != nil else {
                return
            }

            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
}
