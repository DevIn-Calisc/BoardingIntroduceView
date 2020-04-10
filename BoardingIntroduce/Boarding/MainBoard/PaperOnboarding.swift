//
//  PaperOnboarding.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

class PaperOnboarding: UIView {
    @IBOutlet weak open var dataSource: AnyObject? {
        didSet {
            commonInit()
        }
    }
    
    @IBOutlet weak open var delegate: AnyObject?
    
    open fileprivate(set) var currentIndex: Int = 0
    fileprivate(set) var itemsCount: Int = 0
    
    fileprivate var itemsInfo:[BoardingItemModel]?
    
    fileprivate let pageViewBottomConstant: CGFloat
    fileprivate var pageViewSelectedRadius: CGFloat = 22
    fileprivate var pageViewRadius: CGFloat = 8
    
    fileprivate var fillAnimationView: FillAnimationView?
    fileprivate var pageView: PageView?
    
    public fileprivate(set) var gestureControl: GestureControl?
    fileprivate var contentView: BoardContentView?
    
    public init(pageViewBottomConstant: CGFloat = 32) {
        self.pageViewBottomConstant = pageViewBottomConstant
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaperOnboarding {
    fileprivate func backgroundColor(_ index: Int) -> UIColor {
        guard let color = itemsInfo?[index].color else {
            return .black
        }
        return color
    }
    func currentIndex(index: Int, animated: Bool) {
        if 0 ..< itemsCount ~= index {
            (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitionToIndex(index: index)
            currentIndex = index
            
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                (self.delegate as? PaperOnboardingDelegate)?.onboardingDidTransitionToIndex(index: index)
            })
            if let position = self.pageView?.positionItemIndex(index: index, onView: self) {
                fillAnimationView?.fillAnimation(color: backgroundColor(currentIndex), centerPosition: position, duration: 0.5)
            }
            self.pageView?.currentIndex(index: index, animated: animated)
            self.contentView?.currentItem(index: index, animated: animated)
            CATransaction.commit()
        } else if index >= itemsCount {
            (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitionToLeaving()
        }
    }
    
    
    fileprivate func createItemsInfo() -> [BoardingItemModel] {
        guard case let dataSource as PaperOnboardingDataSource = self.dataSource else {
            fatalError("set dataSource")
        }
        var items = [BoardingItemModel]()
        
        for index in 0 ..< itemsCount {
            let info = dataSource.onboardingItem(at: index)
            items.append(info)
        }
        
        return items
    }
    
    
    fileprivate func createPageView() -> PageView {
        let pageView = PageView.pageViewOnView(view: self, itemsCount: itemsCount, bottomConstant: pageViewBottomConstant, radius: pageViewRadius, selectedRadius: pageViewSelectedRadius, itemColor: { [weak self] in
            
            guard let dataSource = self?.dataSource as? PaperOnboardingDataSource else { return .white }
            return dataSource.onboardingPageItemColor(at: $0)
        })
        
        pageView.configuration = {
            [weak self] item, index in
            item.imageView?.image = self?.itemsInfo?[index].pageIcon
        }
        
        return pageView
    }
    func commonInit() {
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            itemsCount = dataSource.onboardingItemsCount()
        }
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            pageViewRadius = dataSource.onboardingPageItemRadius()
        }
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            pageViewSelectedRadius = dataSource.onboardingPageItemSelectedRadius()
        }
        
        //
        self.itemsInfo = createItemsInfo()
        self.translatesAutoresizingMaskIntoConstraints = false
        fillAnimationView = animationViewOnView(view: self, color: backgroundColor(currentIndex))
        contentView = BoardContentView.contentViewOnView(onView: self, delegate: self, itemsCount: itemsCount, bottomConstant: pageViewBottomConstant * -1 - pageViewSelectedRadius)
        
        pageView = createPageView()
        gestureControl = GestureControl(view: self, delegate: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        addGestureRecognizer(tapGesture)
    }
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        guard (delegate as? PaperOnboardingDelegate)?.enableTapsOnPageControl == true, let pageView = self.pageView, let pageControl = pageView.containerView else {
            return
        }
        let touchLocation = gesture.location(in: self)
        let convertedLocation = pageControl.convert(touchLocation, from: self)
        guard let pageItem = pageView.hitTest(convertedLocation, with: nil) else { return }
        let index = pageItem.tag - 1
        guard index != currentIndex else { return }
        currentIndex(index: index, animated: true)
        (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitionToIndex(index: index)
    }
}

extension PaperOnboarding: GestureControlDelegate {
    func gestureControlDidSwipe(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .right:
            currentIndex(index: currentIndex - 1, animated: true)
        case .left:
            currentIndex(index: currentIndex + 1, animated: true)
        default:
            break
        }
    }
}

extension PaperOnboarding: BoardContentViewDelegate {
    func onboardingItemAtIndex(index: Int) -> BoardingItemModel? {
        return itemsInfo?[index]
    }
    func onboardingConfigItem(item: BoardContentViewItem, index: Int) {
        (delegate as? PaperOnboardingDelegate)?.onboardingConfigurationItem(item: item, index: index)
    }
}
