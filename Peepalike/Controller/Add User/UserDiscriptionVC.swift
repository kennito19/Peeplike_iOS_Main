//
//  UserDiscriptionVC.swift
//  Peepalike
//
//  Created by Rao, Bhavesh (external - Project) on 01/04/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class UserDiscriptionVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonCont: UIButton!

    var fname = ""
    var lname = ""
    var bday = ""
    var SelGender = ""
    var loginType = ""
    var userID = ""
    var emailId  = ""
    var phoneNo = ""
    var gender = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "type something about yourself.."
        textView.textColor = .lightGray
        textView.delegate = self
        
        buttonCont.isEnabled = false
        buttonCont.backgroundColor = .darkGray
        
//        textView.becomeFirstResponder()

        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//

    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonConitnueAction(_ sender: Any) {
        
        
        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserShowMeVC") as? UserShowMeVC
        vc?.fname = self.fname
        vc?.lname = self.lname
        vc?.bday = self.bday
        vc?.gender = gender
        vc?.loginType = self.loginType
        vc?.userID = self.userID
        vc?.emailId = self.emailId
        vc?.phoneNo = self.phoneNo
        vc?.desc = self.textView.text
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
}

extension UserDiscriptionVC {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == .systemGray2 {
            
            buttonCont.backgroundColor =  #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            buttonCont.isEnabled = true
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {
            
            buttonCont.backgroundColor =  .darkGray
            buttonCont.isEnabled = false

            textView.text = "type something about yourself..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.isTranslucent = true
        
        doneToolbar.backgroundColor = .clear
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        textView.resignFirstResponder()
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "type something about yourself..."
            textView.textColor = UIColor.lightGray

            buttonCont.backgroundColor =  .darkGray
            buttonCont.isEnabled = false

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            buttonCont.backgroundColor =  #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            buttonCont.isEnabled = true

            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}
