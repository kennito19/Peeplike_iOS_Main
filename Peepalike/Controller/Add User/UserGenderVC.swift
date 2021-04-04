//
//  UserGenderVC.swift
//  Peepalike
//
//  Created by MacBook on 27/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class UserGenderVC: UIViewController
{

    // MARK: - IBOutlets
    @IBOutlet weak var btnFemale: customButton!
    @IBOutlet weak var btnMale: customButton!
    @IBOutlet weak var btnContinue: customButton!
    
    // MARK: - Variables
    var fname = ""
    var lname = ""
    var bday = ""
    var SelGender = ""
    var loginType = ""
    var userID = ""
    var emailId  = ""
    var phoneNo = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnContinue.backgroundColor = .lightGray
        btnContinue.isEnabled = false
        
        print("fname",fname)
        print("lname",lname)
        print("bday",bday)
    }
    
    // MARK: - Button Action
    @IBAction func btnGenderAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            btnFemale.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnFemale.borderColor = .clear
            btnFemale.setTitleColor(.white, for: .normal)
            
            btnMale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnMale.borderColor = .darkGray
            btnMale.setTitleColor(.black, for: .normal)
            
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
            self.SelGender = "female"
        }
        else if sender.tag == 2
        {
            
            btnMale.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnMale.borderColor = .clear
            btnMale.setTitleColor(.white, for: .normal)
            
            btnFemale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnFemale.borderColor = .darkGray
            btnFemale.setTitleColor(.black, for: .normal)
            
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
            self.SelGender = "male"
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any)
    {
        print("fname",fname)
        print("lname",lname)
        print("bday",bday)
        print("SelGender",SelGender)
        print("loginType",loginType)
        print("userID",userID)
        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserDiscriptionVC") as? UserDiscriptionVC
        vc?.fname = self.fname
        vc?.lname = self.lname
        vc?.bday = self.bday
        vc?.gender = self.SelGender
        vc?.loginType = self.loginType
        vc?.userID = self.userID
        vc?.emailId = self.emailId
        vc?.phoneNo = self.phoneNo
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
