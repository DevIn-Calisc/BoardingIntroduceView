//
//  BoarcContentViewItem.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

open class BoardContentViewItem: UIView {
    public var descriptionBottomConstraint: NSLayoutConstraint?
    public var titleCenterConstraint: NSLayoutConstraint?
    public var informationImageWidthConstraint: NSLayoutConstraint?
    public var informationImageHeightConstraint: NSLayoutConstraint?
    
    open var imageView: UIImageView?
    open var titleLabel: UILabel?
    open var descriptionLabel: UILabel?
    
    init(titlePadding: CGFloat, descPadding: CGFloat) {
        super.init(frame: .zero)
        commonInit(titlePadding: titlePadding, descPadding: descPadding)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension BoardContentViewItem {
    func createLabel() -> UILabel {
        return Init(UILabel(frame: .zero), block: {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.textColor = .white
        })
    }
    func createImage(onView view: UIView) -> UIImageView {
        let imageView = Init(UIImageView(frame: .zero), block: {
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        view.addSubview(imageView)
        
        self.informationImageWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 188)
        
        self.informationImageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: 188)
        
        // generate constraint
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        
        return imageView
    }
    
    func createTitleLabel(onView view: UIView, padding: CGFloat) -> UILabel {
        let label = Init(createLabel(), block: {
            $0.numberOfLines = 0
        })
        view.addSubview(label)
        
        // add constraint
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: 10000).isActive = true
        
        //
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: padding).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -padding).isActive = true
        
        //
        return label
    }
    
    
    func createDescriptionLabel(onView view: UIView, padding: CGFloat) -> UILabel {
        let label = Init(createLabel(), block: {
            $0.numberOfLines = 0
        })
        view.addSubview(label)
        
        
        // constraint for height
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: 10000).isActive = true
        
        //
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: padding).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -padding).isActive = true
        
        // center x
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive  = true
        
        // align to bottom
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        
        
        return label
    }
    func commonInit(titlePadding: CGFloat, descPadding: CGFloat) {
        let titleLabel = createTitleLabel(onView: self, padding: titlePadding)
        let descriptionLabel = createDescriptionLabel(onView: self, padding: descPadding)
        let imageView = createImage(onView: self)
        
        
        // added constraints
        self.titleCenterConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 50)
        self.titleCenterConstraint?.isActive = true
        
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10).isActive = true
        
        //
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.imageView = imageView
        
    }
}


extension BoardContentViewItem {
    
    // Same static function
    class func itemOnView(onView view: UIView, titlePadding: CGFloat, descriptionPadding: CGFloat) -> BoardContentViewItem {
        let item = Init(BoardContentViewItem(titlePadding: titlePadding, descPadding: descriptionPadding), block: {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        view.addSubview(item)
        
        // add constraints
        NSLayoutConstraint(item: item, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: 10000).isActive = true
        
        NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        return item
    }
}
