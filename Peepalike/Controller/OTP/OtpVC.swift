//
//  OtpVC.swift
//  Peepalike
//
//  Created by MacBook on 18/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Alamofire
import APESuperHUD

class OtpVC: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt5: UITextField!
    @IBOutlet weak var txt6: UITextField!
    
    // MARK: - Variables
    var phoneNumber = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txt1.becomeFirstResponder()
        txt1.keyboardType = .numberPad
        txt2.keyboardType = .numberPad
        txt3.keyboardType = .numberPad
        txt4.keyboardType = .numberPad
        txt5.keyboardType = .numberPad
        txt6.keyboardType = .numberPad
        
//        sendOtp()
        SendOTPApi()
        
       
    }
    
    // MARK: - Text Action
    @IBAction func txt1EditingChange(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            txt2.becomeFirstResponder()
        }
    }
   
    @IBAction func txtAction(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            txt3.becomeFirstResponder()
        }
    }
    
    @IBAction func txt3Action(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            txt4.becomeFirstResponder()
        }
    }
    
    @IBAction func txt4Action(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            if sender.text!.count >= 1
            {
                txt5.becomeFirstResponder()
            }
            
        }
    }
    
    @IBAction func txt5Action(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            txt6.becomeFirstResponder()
        }
    }
    
    @IBAction func txt6Action(_ sender: UITextField)
    {
        if sender.text!.count >= 1
        {
            print("Go to next screen..")
            let otpNumber = txt1.text! + txt2.text! + txt3.text!
            let otp1 =  txt4.text! + txt5.text! + txt6.text!
            print("Final OTP is->",otpNumber + otp1)
            self.VerifyOTPApi(fotp: otpNumber + otp1)
            
//            self.VerifyOtp(vcode: otpNumber + otp1)
            
//            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartySelectionVC") as? PartySelectionVC
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Button Action
    @IBAction func btnResendOtpAction(_ sender: Any)
    {
        self.SendOTPApi()
    }
    
    
    // MARK:- Otp send and verification
    func sendOtp()
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber, uiDelegate: nil)
        {
            (verificationID, error) in
            if let error = error
            {
                print(error.localizedDescription)
                return
            }
            
            
            print("Phone verification id:-",verificationID)
            UserDefaults.standard.set(verificationID, forKey: SESSION.PhoneVerificaionID)
                        self.view.makeToast("OTP Send.")
            
            
            if verificationID != nil
            {
                
            }
            
        }
    }
    
    func VerifyOtp(vcode:String)
    {
        let verificationID = UserDefaults.standard.string(forKey: SESSION.PhoneVerificaionID)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: vcode)
        
        Auth.auth().signIn(with: credential)
        { (authResult, error) in
            if let error = error
            {
                print("Error ",error.localizedDescription)
//                self.view.makeToast(error.localizedDescription)
                return
            }
            print("Signin done->")
            
            self.view.makeToast("OTP Login Done..")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0)
            {
                // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab") as? MainTabController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
    }
    
    
    // MARK:- API Calling
    func SendOTPApi()
    {
            
            DispatchQueue.main.async
                {
                    APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
            }
            
    //        let uid = UserDefaults.standard.string(forKey: SESSION.UserCode)
    //        print("User Code->",uid)
            
            let parameters: [String: Any] = [
                
                "mobile":self.phoneNumber
                
                
            ]
            
            
        Alamofire.request(URL.init(string: API.SendOTP)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
                print(response.result)
                
                DispatchQueue.main.async
                    {
                        APESuperHUD.dismissAll(animated: true)
                }
                
                switch response.result {
                    
                    
                    
                    
                case .success(_):
                    if let json = response.value
                    {
                        //                    successHandler((json as! [String:AnyObject]))
                        print(json)
                        let t = json as! NSDictionary
                        
                        let error = t["error"] as! String
                        
                        if error == "false"
                        {
                            //go to home screen
                            self.view.makeToast("OTP Sent Sucessfully")
                        }
                        else
                        {
                            self.view.makeToast("Something went wrong!")
                        }
                    }
                    break
                case .failure(let error):
                    //                failureHandler([error as Error])
                    print(error)
                    break
                }
            }
        }
    
    
    func VerifyOTPApi(fotp:String)
    {
            
            DispatchQueue.main.async
                {
                    APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
            }
            
    //        let uid = UserDefaults.standard.string(forKey: SESSION.UserCode)
    //        print("User Code->",uid)
            
            let parameters: [String: Any] = [
                
                "mobile":self.phoneNumber,
                "otp":fotp
                
            ]
            
            
        Alamofire.request(URL.init(string: API.VerifyOTP)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
                print(response.result)
                
                DispatchQueue.main.async
                    {
                        APESuperHUD.dismissAll(animated: true)
                }
                
                switch response.result {
                    
                    
                    
                    
                case .success(_):
                    if let json = response.value
                    {
                        //                    successHandler((json as! [String:AnyObject]))
                        print(json)
                        let t = json as! NSDictionary
                        
                        let error = t["error"] as! String
                        
                        if error == "false"
                        {
                            //go to home screen
                            let user_details = t["user_details"] as! NSDictionary
                            
                            let token = user_details["token"] as! String
                            UserDefaults.standard.set(token, forKey: SESSION.authToken)
                            
                            let user_type = user_details["user_type"] as! String
                            
                            if user_type == "old"
                            {
                                UserDefaults.standard.set(true, forKey: SESSION.isLogin)
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab") as? MainTabController
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                            else
                            {
                                UserDefaults.standard.set(false, forKey: SESSION.isLogin)
                                let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserNameVC") as? UserNameVC
                                vc?.loginType = "new"
                                vc?.phoneNo = self.phoneNumber
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }
                        else
                        {
                            self.view.makeToast("Something went wrong!")
                        }
                    }
                    break
                case .failure(let error):
                    //                failureHandler([error as Error])
                    print(error)
                    break
                }
            }
        }
    
    

}
