//
//  AppSchedulers.swift
//  marvel
//
//  Created by Michel Marques on 20/9/21.
//

import Foundation
import RxSwift

public protocol AppSchedulers {
    var main: ImmediateSchedulerType { get }
    var background: ImmediateSchedulerType { get }
}

class MarvelAppSchedulers: AppSchedulers {
    public let main: ImmediateSchedulerType = MainScheduler.instance
    public let background: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)
}
