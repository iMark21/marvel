//
//  UITableView+Extension.swift
//  marvel
//
//  Created by Michel Marques on 21/9/21.
//

import RxSwift
import RxCocoa

// MARK: - UITableView Extensions

extension UITableView {
    
    func indicatorView() -> UIActivityIndicatorView {
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        } else {
            return activityIndicatorView
        }
    }
    
    func addLoading(closure: @escaping (() -> Void)) {
        if let _ = self.indexPathsForVisibleRows?.last {
            indicatorView().startAnimating()
            indicatorView().isHidden = false
            closure()
        }
    }

    func stopLoading() {
        indicatorView().stopAnimating()
        indicatorView().isHidden = true

        self.tableFooterView = nil
    }
}

// MARK: - UITableView Rx Extensions

extension Reactive where Base: UITableView {

    var nearBottom: Signal<()> {
        func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 20.0) -> Bool {
            return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
        }

        return self.contentOffset.asSignal(onErrorSignalWith: .empty())
            .flatMap { _ in
                return isNearBottomEdge(tableView: self.base)
                    ? .just(())
                    : .empty()
            }
    }
}

extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}

