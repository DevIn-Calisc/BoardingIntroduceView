//
//  FillAnimationView.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

class FillAnimationView: UIView {
    func createCircleLayer(center: CGPoint, color: UIColor) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: center, radius: 1, startAngle: 0, endAngle: 1.0 * CGFloat.pi, clockwise: true)
        let layer = Init(CAShapeLayer()) {
            $0.path = path.cgPath
            $0.fillColor = color.cgColor
            $0.shouldRasterize = true
        }
        self.layer.addSublayer(layer)
        return layer
    }

    func animationToRadius(radius: CGFloat, center: CGPoint, duration: Double) -> CABasicAnimation {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 1.0 * CGFloat.pi, clockwise: true)
        let animation = Init(CABasicAnimation(keyPath: Constant.path)) {
            
            $0.duration = duration
            $0.toValue = path.cgPath
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
            $0.delegate = self
            $0.timingFunction = CAMediaTimingFunction(name: .easeIn)
        }
        return animation
    }
    
    
    func fillAnimation(color: UIColor, centerPosition: CGPoint, duration: Double) {
        let radius = max(bounds.size.width, bounds.size.height) * 1.5
        let circle = createCircleLayer(center: centerPosition, color: color)
        
        let animation = animationToRadius(radius: radius, center: centerPosition, duration: duration)
        animation.setValue(circle, forKey: Constant.circle)
        circle.add(animation, forKey: nil)
    }
}

extension FillAnimationView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let circleLayer = anim.value(forKey: Constant.circle) as? CAShapeLayer else {
            return
        }
        self.layer.backgroundColor = circleLayer.fillColor
        circleLayer.removeFromSuperlayer()
    }
}



func animationViewOnView(view: UIView, color: UIColor) -> FillAnimationView {
    let animationView = Init(FillAnimationView(frame: .zero), block: {
        $0.backgroundColor = color
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    view.addSubview(animationView)
    
    // set constraints
    NSLayoutConstraint.init(item: animationView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint.init(item: animationView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint.init(item: animationView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint.init(item: animationView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    
    // return view
    return animationView
}
