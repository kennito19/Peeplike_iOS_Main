//
//  SignupVC.swift
//  Peepalike
//
//  Created by MacBook on 18/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import SwiftyOnboard
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit
import Toast_Swift
import Alamofire
import APESuperHUD

class SignupVC: UIViewController,SwiftyOnboardDelegate, SwiftyOnboardDataSource,GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if error == nil
        {
            let username = user.profile.name
            let email = user.profile.email
            let imageUrl = user.profile.imageURL(withDimension: 100)
            emailID = email!
            print("username",username)
            print("email",email)
            print("imageUrl",imageUrl)
            
            print("successfully logged into Google",user)
            guard let idToken = user.authentication.idToken else {return}
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if let err = error {
                    print ("failed to create with google account", err)
                    let t = "failed to create with google account " + err.localizedDescription
                    self.view.makeToast(t)
                    return
                }
                print("successfuly logged into Firebase with Google", user?.user.uid)
                let USeridGoogle = user?.user.uid
                let t1 = "Google Login Sucessfull->" + (user?.user.displayName)!
                self.view.makeToast(t1)
                self.LoginAPI(uid: USeridGoogle!, type: "google")
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                    // Change `2.0` to the desired number of seconds.
//                    // Code you want to be delayed
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab") as? MainTabController
//                    self.navigationController?.pushViewController(vc!, animated: true)
//                }
                
            })
            
            
            
        }
        else
        {
            
        }

    }
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int
    {
        return 4
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage?
    {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view?.image.image = UIImage(named: "space\(index).png")
        if index == 0 {
            //On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "Meet a friend"
            view?.subTitleLabel.text = "Find a friends nearby within your current location"
            view?.image.image = #imageLiteral(resourceName: "pexels-photo-2513841")
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "Events"
            view?.subTitleLabel.text = "Someone can find your event base on your location"
            view?.image.image = #imageLiteral(resourceName: "pexels-photo-2705089")
        } else if index == 2 {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "Communities"
            view?.subTitleLabel.text = "Build your relationship that can connected to a person with simiar hobbies, talent and so on"
            view?.image.image = #imageLiteral(resourceName: "5f54e0a523dce")
        }
        else {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "Party"
            view?.subTitleLabel.text = "Get relationship, invite your community and start your own party!"
            view?.image.image = #imageLiteral(resourceName: "Group 11031")
        }
        return view
    }
    
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay?
    {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        
//        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
//        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double)
    {
        
        overlay.skipButton.alpha = 0
        overlay.continueButton.alpha = 0
        overlay.pageControl.alpha = 0
        
        
    }
    
    
    
  
    

    // MARK: - IBOutlets
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    @IBOutlet weak var img: UIImageView!
     @IBOutlet weak var yConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var dict : [String : AnyObject]!
    
    var LoginType = ""
    var userID = ""
    var emailID = ""
 
    
    override func viewWillAppear(_ animated: Bool)
    {
//        yConstraint.constant -= self.view.bounds.height;
//        self.view.updateConstraintsIfNeeded()
//        self.view.layoutIfNeeded()
//        swiftyOnboard.goToPage(index: 1, animated: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
//        UIView.animate(withDuration: 5.0, delay: 0, options: [.repeat, .autoreverse], animations: {
//
//            self.swiftyOnboard.transform = CGAffineTransform(translationX: (-self.swiftyOnboard.frame.width + 30) + self.view.bounds.width, y: 0)
//
//        }, completion: nil)
        
        
        swiftyOnboard.goToPage(index: 1, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.swiftyOnboard.goToPage(index: 0, animated: true)
        }
//        swiftyOnboard.goToPage(index: 0, animated: true)
        
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().delegate = self
        
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.goToPage(index: 1, animated: true)
//        swiftyOnboard.backgroundColor = UIColor(red: 46/256, green: 46/256, blue: 76/256, alpha: 1)
        
        
//        self.LoginAPI(uid: "")
        
    }
    
    // MARK: - Button Action
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            print("Google Signin")
//
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
//            self.LoginAPI(uid: "")
        }
        else if sender.tag == 2
        {
            print("Facebook Signin")
            let fbLoginManager : LoginManager = LoginManager()
//            fbLoginManager.loginBehavior = .browser
            
            fbLoginManager.logIn(permissions: ["email"], from: self, handler: { (result, error) in
                if (error == nil)
                {
                    let fbloginresult : LoginManagerLoginResult = result!
                    
                    if fbloginresult.grantedPermissions != nil
                    {
//                        self.sdLoader.startAnimating(atView: self.view)
                        sender.isEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01)
                        {
                            if(fbloginresult.grantedPermissions.contains("email"))
                            {
                                self.getFBUserData()
                                //fbLoginManager.logOut()
                            }
                        }
                        sender.isEnabled = true
                    }
                }
                else if(result?.isCancelled)!
                {
//                    self.sdLoader.stopAnimation()
                }
            })
        }
        else if sender.tag == 3
        {
            print("PhoneNumber Signin")
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhonenNumberVC") as? PhonenNumberVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    func getFBUserData()
    {
        if((AccessToken.current) != nil)
        {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large),first_name, last_name, email"]).start(completionHandler: { [self] (connection, result, error) -> Void in
                if (error == nil)
                {
                    var facebookID = ""
                    var facebookEmail = ""
                    var facebookName = ""
                    
                    self.dict = result as! [String : AnyObject]
                    if (self.dict["id"] as? String) != nil {
                        facebookID = self.dict["id"] as! String
                    }
                    else
                    {
                        facebookID = "0"
                    }
                    
                    if (self.dict["name"] as? String) != nil
                    {
                        facebookName = self.dict["name"] as! String
                    }
                    else
                    {
                        facebookName = ""
                    }
                    
                    if (self.dict["email"] as? String) != nil {
                        facebookEmail = self.dict["email"] as! String
                    }
                    else
                    {
                        //                        if facebookEmail == ""
                        //                        {
                        //                            let alert = UIAlertController.init(title: "Email Required", message: "Please enter your email", preferredStyle: .alert)
                        //
                        //                        }
                        facebookEmail = ""
                    }
                    
                    // demo users
                    //  "uid": "41", "uUid": "506cec96-a45f-488f-8142-f5acd189c9f2", "role": "2", - Host
                    //  "uid": "47", "uUid": "c679a322-8ad1-44b1-9ee2-8b5aa53e8f7c", "role": "1", - Artist
                    
                    print("facebookID->",facebookID)
                    print("facebookEmail->",facebookEmail)
                    print("facebookName->",facebookName)
                    self.emailID = facebookEmail
                    let t1 = "Facebook Login Sucessfull ,facebookName->" + facebookName
                    self.view.makeToast(t1)
                    
                    self.LoginAPI(uid: facebookID, type: "facebook")
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0)
//                    {
//                        // Change `2.0` to the desired number of seconds.
//                        // Code you want to be delayed
//                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab") as? MainTabController
//                        self.navigationController?.pushViewController(vc!, animated: true)
//                    }
                    
                    
                    

                }
            })
        }
    }
    
    
    // MARK:- API Calling
    func LoginAPI(uid:String,type:String)
    {
        
        DispatchQueue.main.async
            {
                APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        }
        
//        let uid = UserDefaults.standard.string(forKey: SESSION.UserCode)
//        print("User Code->",uid)
        
        let parameters: [String: Any] = [
            
            "type":type,
            "getUserId":uid,
            
        ]
        
        
        Alamofire.request(URL.init(string: API.Login)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
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
                    
                    let success = t["success"] as! Bool
                    
                    if success == true
                    {
                        //go to home screen
                        
                        let data = t["data"] as! NSDictionary
                        
                        let token = data["token"] as! String
                        UserDefaults.standard.set(token, forKey: SESSION.authToken)
                        
                        let user_type = data["user_type"] as! String
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
                                                   vc?.userID = uid
                                                   vc?.loginType = type
                                                    vc?.emailId = self.emailID
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
