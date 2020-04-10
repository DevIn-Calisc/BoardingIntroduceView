//
//  PageView.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

class PageView: UIView {
    var itemsCount: Int = 3
    var itemRadius: CGFloat = 8.0
    var selectedItemRadius: CGFloat = 22.0
    var duration: Double = 0.7
    var space: CGFloat = 20
    let itemColor: (Int) -> UIColor
    
    fileprivate var containerX: NSLayoutConstraint?
    var containerView: PageContainer?
    
    var configuration: ((_ item: PageViewItem,_ index: Int) -> Void)? {
        didSet {
            configurePageItem(items: containerView?.items)
        }
    }
    init(frame: CGRect, itemsCount: Int, radius: CGFloat, selectedRadius: CGFloat, itemColor: @escaping (Int) -> UIColor) {
        self.itemsCount = itemsCount
        self.itemRadius = radius
        self.selectedItemRadius = selectedRadius
        self.itemColor = itemColor
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let containerView = self.containerView, let items = containerView.items else {
            return nil
        }
        for item in items {
            let frame = item.frame.insetBy(dx: -10, dy: -10)
            guard frame.contains(point) else { continue }
            return item
        }
        return nil
    }
}


extension PageView {
    func commonInit() {
        self.containerView = createContainerView()
        currentIndex(index: 0, animated: false)
        backgroundColor = .clear
    }
    
    func currentIndex(index: Int, animated: Bool) {
        if 0 ..< itemsCount ~= index {
            containerView?.currentIndex(index: index, duration: duration * 0.5, animated: animated)
            moveContainerTo(index: index, animated: animated, duration: duration)
        }
    }
    func positionItemIndex(index: Int, onView: UIView) -> CGPoint? {
        
        if 0 ..< itemsCount ~= index {
            if let currentItem = containerView?.items?[index].imageView {
                let pos = currentItem.convert(currentItem.center, to: onView)
                return pos
            }
        }
        return nil
    }
    fileprivate func createContainerView() -> PageContainer {
        let pageControl = PageContainer(radius: itemRadius, selectedRadius: selectedItemRadius, space: space, itemsCount: itemsCount, itemColor: itemColor)
        
        let container = Init(pageControl, block: {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        addSubview(container)
        
        // add constraints
        NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        self.containerX = NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.containerX?.isActive = true
        
        //
        NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: (selectedItemRadius * 2 + CGFloat(itemsCount - 1) * (itemRadius * 2) + space * CGFloat(itemsCount - 1))).isActive = true
        
        return container
    }
    fileprivate func moveContainerTo(index: Int, animated: Bool = true, duration: Double = 0) {
        guard let containerX = self.containerX else {
            return
        }
        
        let containerWidth = CGFloat(itemsCount + 1) * selectedItemRadius + space * CGFloat(itemsCount - 1)
        let toValue = containerWidth / 2.0 - selectedItemRadius - (selectedItemRadius + space) * CGFloat(index)
        containerX.constant = toValue
        
        if animated {
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    
    fileprivate func configurePageItem(items: [PageViewItem]?) {
        guard let items = items else {
            return
        }
        for index in 0 ..< items.count {
            
        }
    }
}


extension PageView {
    class func pageViewOnView(view: UIView, itemsCount: Int, bottomConstant: CGFloat, radius: CGFloat, selectedRadius: CGFloat, itemColor: @escaping (Int) -> UIColor) -> PageView {
        let pageView = PageView(frame: .zero, itemsCount: itemsCount, radius: radius, selectedRadius: selectedRadius, itemColor: itemColor)
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.alpha = 0.4
        view.addSubview(pageView)
        
        NSLayoutConstraint(item: pageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: pageView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: pageView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: pageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30.0).isActive = true
        
        
        return pageView
    }
}
