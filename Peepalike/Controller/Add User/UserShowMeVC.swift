//
//  UserShowMeVC.swift
//  Peepalike
//
//  Created by MacBook on 27/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD
import CoreLocation

class UserShowMeVC: UIViewController, CLLocationManagerDelegate
{

    // MARK: - IBOutlets
    @IBOutlet weak var btnWoman: customButton!
    @IBOutlet weak var btnMan: customButton!
    @IBOutlet weak var btnBoth: customButton!
    @IBOutlet weak var btnContinue: customButton!
    
    // MARK: - Variables
    var fname = ""
    var lname = ""
    var bday = ""
    var gender = ""
    var loginType = ""
    var userID = ""
    var intrest = ""
    var emailId = ""
    var phoneNo = ""
    var desc = ""
    let locationManager = CLLocationManager()
    var lat:Double?
    var long:Double?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnContinue.backgroundColor = .lightGray
        btnContinue.isEnabled = false
        
        print("fname",fname)
        print("lname",lname)
        print("bday",bday)
        print("Gender",gender)
        print("loginType",loginType)
        print("userID",userID)
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        #if targetEnvironment(simulator)
        
        self.lat = -1.4307641240010585
        self.long = 36.978415150080714
        
        #else
        print("dev")
        #endif
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat = locValue.latitude
        self.long = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    
    // MARK: - Button Action
    @IBAction func btnShowmeAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            btnWoman.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnWoman.borderColor = .clear
            btnWoman.setTitleColor(.white, for: .normal)
            
            btnMan.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnMan.borderColor = .darkGray
            btnMan.setTitleColor(.black, for: .normal)
            
            btnBoth.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnBoth.borderColor = .darkGray
            btnBoth.setTitleColor(.black, for: .normal)
            
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
            self.intrest = "female"
        }
        else if sender.tag == 2
        {
            btnWoman.backgroundColor = .white
            btnWoman.borderColor = .darkGray
            btnWoman.setTitleColor(.black, for: .normal)
            
            btnMan.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnMan.borderColor = .clear
            btnMan.setTitleColor(.white, for: .normal)
            
            btnBoth.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnBoth.borderColor = .darkGray
            btnBoth.setTitleColor(.black, for: .normal)
            
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
            self.intrest = "male"
        }
        else if sender.tag == 3
        {
            btnWoman.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnWoman.borderColor = .darkGray
            btnWoman.setTitleColor(.black, for: .normal)
            
            btnMan.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnMan.borderColor = .darkGray
            btnMan.setTitleColor(.black, for: .normal)
            
            btnBoth.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnBoth.borderColor = .clear
            btnBoth.setTitleColor(.white, for: .normal)
            
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)
            btnContinue.isEnabled = true
            self.intrest = "both"
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any)
    {
//        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartySelectionVC") as? PartySelectionVC
////        vc?.fname = self.fname
////        vc?.lname = self.lname
////        vc?.bday = self.bday
////        vc?.gender = self.gender
////        vc?.LoginType = self.loginType
////        vc?.userID = self.userID
//
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        AddUser(lgType: self.loginType)
//        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartySelectionVC") as? PartySelectionVC
//
//
//        self.navigationController?.pushViewController(vc!, animated: true)
//

        
    }
    
    // MARK: - API Calling
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
        else if lgType == "google"
        {
            ft = ""
            gt = self.userID
        }
        
        
        
        
        let parameters: [String: Any] = [
            
            "first_name":self.fname,
            "last_name":self.lname,
            "email":self.emailId,
            "phone_number":self.phoneNo,
            "age":self.bday,
            "address":"",
            "gender":self.gender,
            "max_distance":"",
            "login_type":lgType,
            "facebook_token":ft,
            "google_token":gt,
            "device_token":"fvfvf",
            "os_type":"ios",
            "latitude":"\(self.lat!)",
            "longitude":"\(self.long!)",
            "profile_img":"",
            "interest":self.intrest,
            "age_interest":"",
            "description":self.desc
            
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
                    

                    let token = t["token"] as! String
                    print("Auth token->",token)
                    
                    UserDefaults.standard.setValue(token, forKey: SESSION.authToken)
                    
                    if success == "success"
                    {
                        //go to home screen
                        
                            UserDefaults.standard.set(true, forKey: SESSION.isLogin)
                            
                           
                            
                            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartySelectionVC") as? PartySelectionVC


                            self.navigationController?.pushViewController(vc!, animated: true)
                        
                        
                        
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: SESSION.isLogin)
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
