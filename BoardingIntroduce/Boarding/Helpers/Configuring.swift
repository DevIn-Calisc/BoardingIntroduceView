//
//  Configuring.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import Foundation

internal func Init<T>(_ value: T, block: (_ object: T) -> Void) -> T {
    block(value)
    return value
}
