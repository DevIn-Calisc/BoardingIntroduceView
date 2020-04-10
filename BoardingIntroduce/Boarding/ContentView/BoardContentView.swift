//
//  BoardContentView.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

protocol BoardContentViewDelegate:class {
    func onboardingItemAtIndex(index: Int) -> BoardingItemModel?
    func onboardingConfigItem(item: BoardContentViewItem, index: Int)
}


class BoardContentView: UIView {
    fileprivate var currentItem: BoardContentViewItem?
    weak var delegate: BoardContentViewDelegate?
    
    init(itemsCount: Int, delegate: BoardContentViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        self.currentItem = createItem(index: 0)
    }
    
    fileprivate func createItem(index: Int) -> BoardContentViewItem {
        guard let infor = self.delegate?.onboardingItemAtIndex(index: index) else {
            return BoardContentViewItem.itemOnView(onView: self, titlePadding: 0, descriptionPadding: 0)
        }
        
        let item = Init(BoardContentViewItem.itemOnView(onView: self, titlePadding: infor.titleLabelPadding, descriptionPadding: infor.descriptionLabelPadding), block: {
            $0.imageView?.image = infor.informationImage
            $0.titleLabel?.text = infor.title
            $0.titleLabel?.font = infor.titleFont
            $0.titleLabel?.textColor = infor.titleColor
            
            $0.descriptionLabel?.text = infor.description
            $0.descriptionLabel?.font = infor.descriptionFont
            $0.descriptionLabel?.textColor = infor.descriptionColor
        })
        
        self.delegate?.onboardingConfigItem(item: item, index: index)
        
        return item
    }
}


extension BoardContentView {
    func showItemView(item: BoardContentViewItem, duration: Double) {
        item.descriptionBottomConstraint?.constant = Constant.dyOffsetAnimation
        item.titleCenterConstraint?.constant /= 2
        item.alpha = 0
        layoutIfNeeded()
        
        item.descriptionBottomConstraint?.constant = 0
        item.titleCenterConstraint?.constant *= 2
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            item.alpha = 0
            item.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideItemView(item: BoardContentViewItem?, duration: Double) {
        guard let item = item else {
            return
        }
        
        item.descriptionBottomConstraint?.constant -= Constant.dyOffsetAnimation
        item.titleCenterConstraint?.constant *= 1.3
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            item.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            item.removeFromSuperview()
        }
    }
}


// MARK: Public
extension BoardContentView {
    func currentItem(index: Int, animated: Bool) {
        let showItem = createItem(index: index)
        showItemView(item: showItem, duration: Constant.showDuration)
        
        hideItemView(item: currentItem, duration: Constant.hideDuration)
        
        currentItem = showItem
    }
    
    class func contentViewOnView(onView view: UIView, delegate: BoardContentViewDelegate, itemsCount: Int, bottomConstant: CGFloat) -> BoardContentView {
        let contentView = Init(BoardContentView(itemsCount: itemsCount, delegate: delegate), block: {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        view.addSubview(contentView)
        
        // add constraint
        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: bottomConstant).isActive = true
        
    }
}


