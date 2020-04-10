//
//  PaperOnboardingDelegate.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import Foundation

public protocol PaperOnboardingDelegate {
    func onboardingWillTransitionToLeaving()
    
    func onboardingDidTransitionToIndex(index: Int)
    
    func onboardingConfigurationItem(item: BoardContentViewItem, index: Int)
    
    var enableTapsOnPageControl: Bool { get }
}

// This extension will make delegate method optional
public extension PaperOnboardingDelegate {
    func onboardingWillTransitionToIndex(index: Int) {}
    func onboardingDidTransitionToIndex(index: Int) { }
    func onboardingWillTransitionToLeaving() { }
    func onboardingConfigurationItem(item: BoardContentViewItem, index: Int) { }
    var enableTapsOnPageControl: Bool { return true }
}
