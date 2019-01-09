//
//  Timer.swift
//  AlphabetOrder
//
//  Created by Satvik Borra on 12/19/16.
//  Copyright © 2016 vborra. All rights reserved.
//

import UIKit

class CircleTimer : UIView, CAAnimationDelegate{

    static let null = CircleTimer(frame: CGRect.zero, lineWidth: 0);
    
    var done = {}
    
    var progressLayer : CAShapeLayer = CAShapeLayer()
 
    var circle : CAShapeLayer!
    var main : CAShapeLayer!
    init(frame : CGRect, lineWidth : CGFloat){
        super.init(frame: frame);
        
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: frame.size.width/2, startAngle: CGFloat.pi*(3/2), endAngle:  -CGFloat.pi/2, clockwise: false)//UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)).cgPath
//        path.fill()
        
        progressLayer = CAShapeLayer()
//        progressLayer.fillColor = UIColor.red.cgColor
        progressLayer.strokeColor = UIColor.red.cgColor
        
        progressLayer.lineWidth = 3;
        progressLayer.strokeStart = 0
        progressLayer.path = path.cgPath
        progressLayer.strokeEnd = 0
        progressLayer.opacity = 0
        
        
        
//        progressLayer.shadowRadius = 15
//        progressLayer.shadowOpacity = 0.9
//        progressLayer.shadowOffset = CGSize.zero
        progressLayer.masksToBounds = false
        
//        self.layer.addSublayer(progressLayer)
        
        self.layer.borderWidth = 3
        
        main = CAShapeLayer()
        main.bounds = self.bounds
        main.backgroundColor = UIColor.red.cgColor

        circle = CAShapeLayer()
        circle.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: frame.size)).cgPath
        circle.strokeColor = UIColor.red.cgColor;
        circle.fillColor = UIColor.blue.cgColor;
        main.mask = circle
        main.mask?.frame = main.bounds
        self.layer.addSublayer(main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func start(time : CGFloat){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(1.0)
        animation.toValue = CGFloat(0.0)
        animation.duration = CFTimeInterval(time)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.backwards
        progressLayer.add(animation, forKey: "timer")
    }
    
    func reset(time : CGFloat){
        progressLayer.removeAnimation(forKey: "timer")
        start(time: time)
    }
    
    func removeTimer(){
        progressLayer.removeAnimation(forKey: "timer")
    }
    
    func pause(){
        progressLayer.speed = 0
    }
    
    func resume(){
        progressLayer.speed = 1
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag){
            timerFinished()
        }
    }
    
    func timerFinished(){
        self.done()
    }
    
    func getCenterPos(pos : CGPoint) -> CGPoint{
        return CGPoint(x: pos.x-(frame.size.width/2), y: pos.y-(frame.size.height/2));
    }
    
    func animateIn(time : CGFloat){
//        UIView.animate(withDuration: TimeInterval(time), animations: {
//            self.frame.origin = self.getCenterPos(pos: self.inPos);
//        })
        
//        let fadeIn = CABasicAnimation(keyPath: "opacity")
//        fadeIn.fromValue = 0
//        fadeIn.toValue = 1
//        fadeIn.duration = CFTimeInterval(time);
//        fadeIn.isRemovedOnCompletion = false
//        fadeIn.fillMode = kCAFillModeForwards
//        progressLayer.add(fadeIn, forKey: "fadeIn")
        
        progressLayer.opacity = 1
    }
    
    func animateOut(time : CGFloat){
//        UIView.animate(withDuration: TimeInterval(time), animations: {
//            self.frame.origin = self.getCenterPos(pos: self.outPos);
//        })
        
//        let fadeOut = CABasicAnimation(keyPath: "opacity")
//        fadeOut.fromValue = 1
//        fadeOut.toValue = 0
//        fadeOut.duration = CFTimeInterval(time);
//        fadeOut.isRemovedOnCompletion = false
//        fadeOut.fillMode = kCAFillModeForwards
//        progressLayer.add(fadeOut, forKey: "fadeOut")
        
        progressLayer.opacity = 0
    }
}

