//
//  PageViewItem.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

class PageViewItem: UIView {
    let circleRadius: CGFloat
    let selectedCircleRadius: CGFloat
    let lineWidth: CGFloat
    let itemColor: UIColor
    
    var select: Bool
    
    var centerView: UIView?
    var imageView: UIImageView?
    var circleLayer: CAShapeLayer?
    var tickIndex: Int = 0
    
    init(radius: CGFloat, itemColor: UIColor, selectedRadius: CGFloat, lineWidth: CGFloat = 3, isSelect: Bool = false) {
        self.itemColor = itemColor
        self.circleRadius = radius
        self.selectedCircleRadius = selectedRadius
        self.lineWidth = lineWidth
        self.select = isSelect
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageViewItem {
    fileprivate func createBorderView() -> UIView {
        let view = Init(UIView(frame: .zero), block: {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        addSubview(view)
        
        // create a circle layer
        let currentRadius = select == true ? selectedCircleRadius : circleRadius
        let circleLayer = createCircleLayer(radius: currentRadius, lineWidth: lineWidth)
        view.layer.addSublayer(circleLayer)
        self.circleLayer = circleLayer
        
        // add constraints
        NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        //
        return view
    }
    fileprivate func createCircleLayer(radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: .zero, radius: radius - lineWidth / 2, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        let layer = Init(CAShapeLayer(), block: {
            $0.path = path.cgPath
            $0.lineWidth = lineWidth
            $0.strokeColor = itemColor.cgColor
            $0.fillColor = UIColor.clear.cgColor
        })
        
        return layer
    }
    fileprivate func createImageView() -> UIImageView {
        let imageView = Init(UIImageView(frame: .zero), block: {
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alpha = select == true ? 1 : 0
        })
        self.addSubview(imageView)
        
        //
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        //
        return imageView
    }
}

extension PageViewItem {
    fileprivate func circleScaleAnimation(toRadius: CGFloat, duration: Double) -> CABasicAnimation {
        let path = UIBezierPath(arcCenter: .zero, radius: toRadius, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        
        let animation = Init(CABasicAnimation(keyPath: Constant.path), block: {
            $0.duration = duration
            $0.toValue = path.cgPath
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
        })
        return animation
    }
    fileprivate func imageAlphaAnimation(toValue: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.imageView?.alpha = toValue
        }, completion: nil)
    }
    fileprivate func circleBackgroundAnimation(toColor: UIColor, duration: Double) -> CABasicAnimation {
        let animation = Init(CABasicAnimation(keyPath: "fillColor"), block: {
            $0.duration = duration
            $0.toValue = toColor.cgColor
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
            $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        })
        return animation
    }
    func animationSelected(selected: Bool, duration: Double, fillColor: Bool) {
        let toAlpha: CGFloat = select == true ? 1 : 0
        imageAlphaAnimation(toValue: toAlpha, duration: duration)
        
        let currentRadius = selected ? selectedCircleRadius : circleRadius
        let scaleAnimation = circleScaleAnimation(toRadius: currentRadius - lineWidth / 2.0, duration: duration)
        let toColor = fillColor ? itemColor : .clear
        let colorAnimation = circleBackgroundAnimation(toColor: toColor, duration: duration)
        
        self.circleLayer?.add(scaleAnimation, forKey: nil)
        self.circleLayer?.add(colorAnimation, forKey: nil)
    }
    func commonInit() {
        centerView = createBorderView()
        imageView = createImageView()
    }
}
