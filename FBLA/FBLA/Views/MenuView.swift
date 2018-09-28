//
//  MenuView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol MenuViewDelegate : class {
    func menuPlayButtonPressed()
}

class MenuView : View{
    
    weak var delegate: MenuViewDelegate?
    var title : Label!
    var button : Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.2, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.25, y: 0.2, width: 0.5, height: 0.2), frame: self.frame))
        title.text = "FBLA";
        self.addSubview(title)
        
        button = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.25, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), text: "play")
        button.pressed = {
            print("PLAY")
            self.delegate?.menuPlayButtonPressed()
        }
        self.addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        button.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        button.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
}
