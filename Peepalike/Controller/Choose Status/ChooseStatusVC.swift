//
//  ChooseStatusVC.swift
//  Peepalike
//
//  Created by MacBook on 22/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import APESuperHUD
import Alamofire

class ChooseStatusVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.userStatusData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
        let data = self.userStatusData[indexPath.row]
        cell.labelStatusTitle?.text = (data["status_name"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.userStatusData[indexPath.row]
        self.labelStaus.text = (data["status_name"] as! String)
        userSelectedStatusID = (data["id"] as! Int)
        self.updateUserStaus()
    }
    
    @IBOutlet weak var imageView: RoundableImageView!
    
    @IBOutlet weak var labelStaus: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!

    var userName = ""
    var image:UIImage?
    var status = ""
    
    var userStatusData = [NSDictionary]()
    var userSelectedStatusID:Int?
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgClose.image = imgClose.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgClose.tintColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        labelTitle.text = userName
        imageView.image = image
        self.labelStaus.text = status
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.userStatusListAPI()
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
          _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func userStatusListAPI()
    {
        self.userStatusData.removeAll()
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [:]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "userStatusList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
                          DispatchQueue.main.async
                                        {
                                            APESuperHUD.dismissAll(animated: true)
                                    }
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
//
                            let groups = t["status"] as! NSArray
                            for i in groups
                            {
                                let t = i as! NSDictionary
                                self.userStatusData.append(t)
                            }
                            self.tbl.reloadData()
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                                
                        }
                        
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
    
    func updateUserStaus()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: Any] = [
            "user_status" : userSelectedStatusID]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "updateUserStatus"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
                          DispatchQueue.main.async
                                        {
                                            APESuperHUD.dismissAll(animated: true)
                                    }
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
//
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                                
                        }
                        
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
