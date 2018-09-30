//
//  QuestionView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

enum QuestionType {
    case MultipleChoice
    case Text
    case Number
}

protocol QuestionViewDelegate : class {
    func submitButtonPressed(correctAnswer: Bool, correctAnswerText: String)
}

class QuestionView : View, QuestionChoiceViewDelegate {
   
    weak var delegate : QuestionViewDelegate?
    
    var questionTextLabel : Label!
    var questionType : QuestionType!
    
    var choiceViews : [QuestionChoiceView] = []
    
    var inputField : UITextField!;
    var numberInputOnly : Bool = false
    
    var submitButton : Button!
    
    init(frame: CGRect, question : Question) {
        super.init(frame: frame)
        
        switch question.choiceType.lowercased() {
        case "mc":
            questionType = .MultipleChoice
            break;
        case "txt":
            questionType = .Text
            break;
        case "num":
            questionType = .Number
            break;
        default:
            questionType = .MultipleChoice
            break;
        }
        
        
        var submitButtonFrame : CGRect! = CGRect.zero
        var submitButtonFrameOut : CGRect! = CGRect.zero

        var questionFrame : CGRect! = CGRect.zero
        var questionFrameOut : CGRect! = CGRect.zero

        if(question.choices.keys.count > 0){ //TODO or questionType == mc?
            var choices : [QuestionChoice] = []
            for (choiceName, choiceValue) in question.choices {
                var isCorrectAnswer : Bool = false
                if(choiceName == question.correctAnswer){
                    isCorrectAnswer = true
                }
                // TODO, ensure there is a correct value
                let choice = QuestionChoice(choiceValue: choiceValue, correctAnswer: isCorrectAnswer)
                choices.append(choice)
            }
            
            /*  TODO shuffle choices here  */
            
            choices.shuffle()
            
            
            var i : Int = 0
            let cellHeight : CGFloat = 0.12
            let verticalPadding : CGFloat = 0.0066
            let topOffset : CGFloat = 0.3
            
            for choice in choices {
                let choiceViewOutFrame = propToRect(prop: CGRect(x: i%2 == 0 ? -1 : 1, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 1, height: cellHeight), frame: self.frame)

                let choiceViewInFrame = propToRect(prop: CGRect(x: 0, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 1, height: cellHeight), frame: self.frame)
                let choiceView = QuestionChoiceView(outFrame: choiceViewOutFrame, inFrame: choiceViewInFrame, choice: choice, choiceId: i, selected: false)
                choiceView.delegate = self
                choiceViews.append(choiceView)
                self.addSubview(choiceView)
                i += 1;
            }
            
            submitButtonFrame = propToRect(prop: CGRect(x: 0, y: 0.8, width: 1, height: 0.2), frame: self.frame)
            submitButtonFrameOut = propToRect(prop: CGRect(x: -1, y: 0.8, width: 1, height: 0.2), frame: self.frame)

            questionFrame = propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.3), frame: self.frame)
            questionFrameOut = propToRect(prop: CGRect(x: 0, y: -0.3, width: 1, height: 0.3), frame: self.frame)

        }else if(questionType == .Number || questionType == .Text){
            inputField = UITextField(frame: propToRect(prop: CGRect(x: 0.05, y: 0.325, width: 0.9, height: 0.1), frame: self.frame))
            inputField.placeholder = "Enter answer here"
            inputField.font = UIFont.systemFont(ofSize: 15)
            inputField.borderStyle = UITextField.BorderStyle.roundedRect
            inputField.autocorrectionType = UITextAutocorrectionType.no
            inputField.keyboardType = questionType == .Number ? UIKeyboardType.numberPad : UIKeyboardType.alphabet
            inputField.returnKeyType = UIReturnKeyType.done
            inputField.clearButtonMode = UITextField.ViewMode.whileEditing;
            inputField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            inputField.delegate = self
            self.addSubview(inputField)
            
            numberInputOnly = questionType == .Number
            
            submitButtonFrame = propToRect(prop: CGRect(x: 0.05, y: 0.45, width: 0.9, height: 0.1), frame: self.frame)
            submitButtonFrameOut = propToRect(prop: CGRect(x: -0.9, y: 0.45, width: 0.9, height: 0.1), frame: self.frame)

            questionFrame = propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.3), frame: self.frame)
            questionFrameOut = propToRect(prop: CGRect(x: -1, y: 0, width: 1, height: 0.3), frame: self.frame)

        }
        
        
        
        questionTextLabel = Label(outFrame: questionFrameOut, inFrame: questionFrame, text: question.question, textColor: UIColor.black, valign: .Default, _insets: false)
        questionTextLabel.textAlignment = .center
        questionTextLabel.layer.borderWidth = 2
        questionTextLabel.layer.borderColor = UIColor.yellow.cgColor
        self.addSubview(questionTextLabel)
        
        submitButton = Button(outFrame: submitButtonFrameOut, inFrame: submitButtonFrame, text: "Submit")
        submitButton.pressed = {
            print("SUBMIT")
            if(self.questionType != .MultipleChoice){
                self.inputField.resignFirstResponder()
            }
            
            self.delegate?.submitButtonPressed(correctAnswer: self.questionType == .MultipleChoice ? self.testIfCurrentlySelectedIsAnswer() : question.correctAnswer.contains(self.inputField.text!), correctAnswerText: self.questionType == .MultipleChoice ? self.getCorrectAnswerText() : question.correctAnswer)
        }
        self.addSubview(submitButton)
    }
    
    
    //TODO replace selectedButton.enabled with isSelected()
    func testIfCurrentlySelectedIsAnswer() -> Bool{
        for view in choiceViews {
            if view.selectedButton.enabled == true {
                return view.choice!.correctAnswer
            }
        }
        return false
    }
    
    func getCorrectAnswerText() -> String{
        for view in choiceViews {
            if view.choice.correctAnswer == true {
                return view.choice!.choiceValue
            }
        }
        return ""
    }
    
    func selectionChange(choiceView : QuestionChoiceView, selected: Bool) {
        for view in choiceViews{
            if view.choiceId != choiceView.choiceId {
                view.selectedButton.enabled = false
                view.selectedButton.updateUIForSelection()
            }
        }
    }
    
    //TODO
    override func animateIn(completion: @escaping () -> Void) {
        for choiceView in choiceViews {
            choiceView.animateIn()
        }
        
        questionTextLabel.animateIn()
        submitButton.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {

        for choiceView in choiceViews {
            choiceView.animateOut()
        }
        
        questionTextLabel.animateOut()
        submitButton.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuestionView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(numberInputOnly){
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        }else{
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
    
}
