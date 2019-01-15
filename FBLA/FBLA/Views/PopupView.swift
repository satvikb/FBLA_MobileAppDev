//
//  PopupView.swift
//  FBLA
//
//  Created by Satvik Borra on 1/14/19.
//  Copyright © 2019 satvik borra. All rights reserved.
//

import UIKit

protocol PopupViewDelegate : class {
    func dismiss()
}

// Popup view to show text
class PopupView : View {
    
    weak var delegate : PopupViewDelegate?
    
    // Animation variables
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    // UI variables
    var titleLabel : Label!
    var textLabel : UITextView!
    var dismissButton : Button!
    
    init(outFrame: CGRect, inFrame: CGRect, title : String, text : String) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        // Create UI
        let titleLabelFrame = propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.1), frame: self.frame)
        titleLabel = Label(outFrame: titleLabelFrame, inFrame: titleLabelFrame, text: title, textColor: UIColor.black, valign: .Default, _insets: false)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 10
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 40))
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        let textLabelFrame = propToRect(prop: CGRect(x: 0.05, y: 0.2, width: 0.9, height: 0.55), frame: self.frame)

        textLabel = UITextView(frame: textLabelFrame)
        textLabel.text = text
        textLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 22.5))
        textLabel.textAlignment = .center
        textLabel.isEditable = false
        textLabel.returnKeyType = .done

        self.addSubview(textLabel)
        
        let dismissButtonFrame = propToRect(prop: CGRect(x: 0.1, y: 0.8, width: 0.8, height: 0.15), frame: self.frame)
        dismissButton = Button(outFrame: dismissButtonFrame, inFrame: dismissButtonFrame, text: "Ok")
        dismissButton.pressed = {
            self.delegate?.dismiss()
        }
        self.addSubview(dismissButton)
        
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.width/10
        
    }
    
    // Animation functions
    override func animateIn(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame = self.inFrame
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame = self.outFrame
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
