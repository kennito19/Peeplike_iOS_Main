//
//  AddUserVC.swift
//  Peepalike
//
//  Created by MacBook on 10/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import APESuperHUD
import Alamofire

class AddUserVC: UIViewController
{

    // MARK: - IBOutlets
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    
    @IBOutlet weak var vwPhone: RoundableView!
    // MARK: - Variables
    var LoginType = ""
    var userID = ""
    var fromScreen = ""
    var PhoneNmber = ""
    
    var fname = ""
    var lname = ""
    var bday = ""
    var gender = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ChangeImageTint(img: img1)
        ChangeImageTint(img: img2)
        ChangeImageTint(img: img3)
        print("LoginType->",LoginType)
        print("User id->",userID)
        
        print("fname",fname)
        print("lname",lname)
        print("bday",bday)
        print("Gender",gender)
        
        if fromScreen == "otp"
        {
//            vwPhone.alpha = 0
            self.txtPhoneNumber.isUserInteractionEnabled = false
            self.txtPhoneNumber.text = PhoneNmber
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func btnSaveAction(_ sender: Any)
    {
        if self.txtFullname.text == ""
        {
            self.view.makeToast("Please Enter Fullname")
        }
        else if self.txtEmail.text == ""
        {
            self.view.makeToast("Please Enter Email ID")
        }
        else if self.txtPhoneNumber.text == ""
        {
            if fromScreen == "otp"
            {
                AddUser(lgType: LoginType)
            }
            else
            {
                self.view.makeToast("Please Enter PhoneNumber")
            }
            
        }
        else
        {
            AddUser(lgType: LoginType)
        }
    }
    
    
    func ChangeImageTint(img:UIImageView)
    {
        img.image = img.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        img.tintColor = #colorLiteral(red: 0.3176470588, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
        
    }
    
    //MARK:- Api calling
    func AddUser(lgType:String)
    {
        
        DispatchQueue.main.async
            {
                APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        }
        
//        let uid = UserDefaults.standard.string(forKey: SESSION.UserCode)
//        print("User Code->",uid)
        
        var ft = ""
        var gt = ""
        
        if lgType == "facebook"
        {
            ft = self.userID
            gt = ""
        }
        else if lgType == "new"
        {
            ft = ""
            gt = ""
        }
        else
        {
            ft = ""
            gt = self.userID
        }
        
        let parameters: [String: Any] = [
            
            "first_name":self.txtFullname.text!,
            "last_name":"",
            "email":self.txtEmail.text!,
            "phone_number":self.txtPhoneNumber.text!,
            "age":"",
            "address":"",
            "gender":"",
            "max_distance":"",
            "login_type":lgType,
            "facebook_token":ft,
            "google_token":gt,
            "device_token":"fvfvf",
            "os_type":"ios",
            "latitude":"",
            "longitude":"",
            "profile_img":"",
            "age_interest":"",
            
        ]
        
        print("Adduser Parameters->",parameters)
        
        
        Alamofire.request(URL.init(string: API.AddUser)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
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
                    print(t)
                    
                    let success = t["error_message"] as! String
                    
                    if success == "success"
                    {
                        //go to home screen
                        if self.fromScreen == "otp"
                        {
                            UserDefaults.standard.set(true, forKey: SESSION.isLogin)
                            
                           
                            
                            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartySelectionVC") as? PartySelectionVC


                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        else
                        {
                            UserDefaults.standard.set(false, forKey: SESSION.isLogin)
                            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                            vc?.phoneNumber = self.txtPhoneNumber.text!
                            
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        
                        
                    }
                    else
                    {
                        self.view.makeToast("Something went wrong!")
                    }
                    
//                    let t1 = t[0] as! NSDictionary
//                    print(t1)
//
//                    let statusCode = t1["statusCode"] as! NSNumber
//                    print(statusCode)
                    
                   
                    
                    
                    
                    
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
