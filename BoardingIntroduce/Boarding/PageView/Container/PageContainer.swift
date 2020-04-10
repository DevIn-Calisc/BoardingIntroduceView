//
//  PageContainer.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

class PageContainer: UIView {
    var items: [PageViewItem]?
    let space: CGFloat // space between items
    var currentIndex = 0
    
    fileprivate let itemRadius: CGFloat
    fileprivate let selectedItemRadius: CGFloat
    fileprivate let itemsCount: Int
    fileprivate let animationkey = "animationKey"
    
    init(radius: CGFloat, selectedRadius: CGFloat, space: CGFloat, itemsCount: Int, itemColor: (Int) -> UIColor) {
        self.itemsCount = itemsCount
        self.space = space
        self.itemRadius = radius
        self.selectedItemRadius = selectedRadius
        super.init(frame: .zero)
        
        self.items = self.createItems(count: itemsCount, radius: radius, selectedRadius: selectedRadius, itemColor: itemColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageContainer {
    fileprivate func addConstraintsToView(item: UIView, radius: CGFloat) {
        NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        let widthCS = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: radius * 2.0)
        widthCS.identifier = animationkey
        widthCS.isActive = true
        
        let heightCS = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: radius * 2.0)
        heightCS.identifier = animationkey
        heightCS.isActive = true
    }
    
    fileprivate func addConstraintsToView(view item: UIView, leftItem: UIView, radius: CGFloat) {
        NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: leftItem, attribute: .trailing, multiplier: 1.0, constant: space).isActive = true
        
        
        NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: radius * 2.0).isActive = true
        NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: radius * 2.0).isActive = true
        
    }
    fileprivate func createItem(radius: CGFloat, selectedRadius: CGFloat, isSelect: Bool = false, itemColor: UIColor) -> PageViewItem {
        let item = Init(PageViewItem(radius: radius, itemColor: itemColor, selectedRadius: selectedRadius, lineWidth: 3, isSelect: isSelect), block: {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        })
        self.addSubview(item)
        
        return item
    }
    
    fileprivate func createItems(count: Int, radius: CGFloat, selectedRadius: CGFloat, itemColor: (Int) -> UIColor) -> [PageViewItem] {
        var items = [PageViewItem]()
        
        // crate first item
        var tag = 1
        var item = createItem(radius: radius, selectedRadius: selectedRadius, isSelect: true, itemColor: itemColor(tag - 1))
        item.tag = tag
        
        addConstraintsToView(item: item, radius: selectedRadius)
        items.append(item)
        
        
        for _ in 1 ..< count {
            tag += 1
            let nextItem = createItem(radius: radius, selectedRadius: selectedRadius, itemColor: itemColor(tag - 1))
            addConstraintsToView(view: nextItem, leftItem: item, radius: radius)
            
            items.append(nextItem)
            item = nextItem
            item.tag = tag
        }
        
        return items
    }
    
    
    fileprivate func animationItem(item: PageViewItem, selected: Bool, duration: Double, fillColor: Bool = false) {
        let toValue = selected ? selectedItemRadius * 2 : itemRadius * 2
        item.constraints
            .filter({ $0.identifier == "animationKey"})
            .forEach({
                $0.constant = toValue
            })
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        item.animationSelected(selected: selected, duration: duration, fillColor: fillColor)
    }
}


// MARK: public

extension PageContainer {
    func currentIndex(index: Int, duration: Double, animated: Bool) {
        guard let items = self.items, index != currentIndex else { return }
        
        animationItem(item: items[index], selected: true, duration: duration)
        
        let fillColor = index > currentIndex ? true : false
        
        animationItem(item: items[currentIndex], selected: false, duration: duration, fillColor: fillColor)
        
        currentIndex = index
    }
}
