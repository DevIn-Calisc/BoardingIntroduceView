//
//  GestureControl.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/8/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

protocol GestureControlDelegate: class {
    func gestureControlDidSwipe(direction: UISwipeGestureRecognizer.Direction)
}

class GestureControl: UIView {
    weak var delegate: GestureControlDelegate!
    
    public private(set) var swipeLeft: UISwipeGestureRecognizer!
    public private(set) var swipeRight: UISwipeGestureRecognizer!
    
    
    init(view: UIView, delegate: GestureControlDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        self.swipeLeft.direction = .left
        addGestureRecognizer(self.swipeLeft)
        
        
        self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        self.swipeRight.direction = .right
        addGestureRecognizer(self.swipeRight)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        view.addSubview(self)
        
        // add contraints
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GestureControl {
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer) {
        self.delegate.gestureControlDidSwipe(direction: gesture.direction)
    }
}
