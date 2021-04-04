//
//  UserBirthdateVC.swift
//  Peepalike
//
//  Created by MacBook on 27/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class UserBirthdateVC: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var txtDD: UITextField!
    @IBOutlet weak var txtMM: UITextField!
    @IBOutlet weak var txtYYYY: UITextField!
    @IBOutlet weak var btnContinue: customButton!
    
    // MARK: - Variables
    var fname = ""
    var lname = ""
    var loginType = ""
    var userID = ""
    var emailId = ""
    var phoneNo = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnContinue.backgroundColor = .lightGray
        btnContinue.isEnabled = false
        
        txtDD.keyboardType = .numberPad
        txtMM.keyboardType = .numberPad
        txtYYYY.keyboardType = .numberPad
        
        print("fname",fname)
        print("lname",lname)
        
        
    
    }
    
    // MARK: - Text Action
    @IBAction func DDDidEnd(_ sender: UITextField)
    {
        if sender.text!.count < 2
        {
            self.view.makeToast("Enter Proper Date")
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtMM.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtYYYY.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else
        {
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
        }
    }
    
    @IBAction func MMDidEnd(_ sender: UITextField)
    {
        if sender.text!.count < 2
        {
            self.view.makeToast("Enter Proper Month")
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtDD.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtYYYY.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else
        {
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
        }
    }
    
    @IBAction func YYYYDidEnd(_ sender: UITextField)
    {
        if sender.text!.count < 2
        {
            self.view.makeToast("Enter Proper Year")
        }
        else if txtMM.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtDD.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else
        {
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnContinueAction(_ sender: Any)
    {
//
        
        
        let bday = self.txtDD.text! + "/" + self.txtMM.text! + "/" + self.txtYYYY.text!
//        let t = self.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: bday)
        
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        print(formatter.string(from: bday))
        
        let now = Date()
        let birthday: Date = date!
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        print("Age is->",age)
        
        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserGenderVC") as? UserGenderVC
            vc?.fname = self.fname
            vc?.lname = self.lname
            vc?.bday = age.description
            vc?.loginType = self.loginType
            vc?.userID = self.userID
            vc?.emailId = self.emailId
            vc?.phoneNo  = self.phoneNo
            self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    

}
