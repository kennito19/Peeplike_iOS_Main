//
//  UserNameVC.swift
//  Peepalike
//
//  Created by MacBook on 27/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class UserNameVC: UIViewController
{

    // MARK: - IBOutlets
    @IBOutlet weak var txtFirstname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var btnContinue: customButton!
    
    // MARK: - Variables
    var loginType = ""
    var userID = ""
    var phoneNo = ""
    var emailId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnContinue.backgroundColor = .lightGray
        btnContinue.isEnabled = false
    }
    
    // MARK: - Text  Action
    @IBAction func firstNameDidEndAction(_ sender: UITextField)
    {
        if sender.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtLastName.text == ""
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
    
    @IBAction func lastnameDidEndction(_ sender: UITextField)
    {
        if sender.text == ""
        {
            btnContinue.backgroundColor = .lightGray
            btnContinue.isEnabled = false
        }
        else if txtFirstname.text == ""
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
        print("Continue..")
        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserBirthdateVC") as? UserBirthdateVC
        vc?.fname = self.txtFirstname.text!
        vc?.lname = self.txtLastName.text!
        vc?.loginType = self.loginType
        vc?.userID = self.userID
        vc?.emailId = self.emailId
        vc?.phoneNo = self.phoneNo
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}
