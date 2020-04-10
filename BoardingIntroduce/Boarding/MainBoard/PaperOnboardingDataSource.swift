//
//  PaperOnboardingDataSource.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import Foundation
import UIKit

public protocol PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int
    
    func onboardingItem(at index: Int) -> BoardingItemModel
    
    func onboardingPageItemColor(at index: Int) -> UIColor
    
    func onboardingPageItemRadius() -> CGFloat
    
    func onboardingPageItemSelectedRadius() -> CGFloat
}

public extension PaperOnboardingDataSource {
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return .white
    }
    
    func onboardingPageItemRadius() -> CGFloat {
        return 8
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 22
    }
}
