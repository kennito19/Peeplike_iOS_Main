//
//  PartyDetailsVC.swift
//  Peepalike
//
//  Created by MacBook on 22/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import APESuperHUD
import Alamofire


class PartyDetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionBannerImages {
            return bannerImagesData.count
        }
        return  self.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView ==  collectionBannerImages {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as! BannerImageCollectionViewCell
            
            let event_image = bannerImagesData[indexPath.item]["banner_image"] as! String
            let url = URL(string: event_image)
            cell.imageViewBanner.kf.setImage(with: url)

            return cell
        }
        let cell = CollPartiesAtte.dequeueReusableCell(withReuseIdentifier: "PartyDetailsCell", for: indexPath) as! PartyDetailsCell
        let data = self.userList[indexPath.item]
      
        if let imaeg = data["image"] as? String{
            if !imaeg.isEmpty{
                let url = URL(string: imaeg)
                if url != nil {
                    cell.imageViewUser.kf.setImage(with: url)
                }else{
                    cell.imageViewUser.image = UIImage(named: "defaultUser")
                }
            }else{
                cell.imageViewUser.image = UIImage(named: "defaultUser")
            }
        }else{
            cell.imageViewUser.image = UIImage(named: "defaultUser")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == collectionBannerImages {
            return CGSize(width: UIScreen.main.bounds.width - 20, height: 245)
        }
       return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
        let data = self.userList[indexPath.item]
        vc?.userID = (data["id"] as! Int)
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    @IBOutlet weak var buttonJoin: UIButton!
    // MARK: - IBOutlets
    @IBOutlet weak var CollPartiesAtte: UICollectionView!
    @IBOutlet weak var labelRattiing: UILabel!
    
    @IBOutlet weak var textViewDescp: UITextView!
    @IBOutlet weak var labelNumberOfAttandee: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionBannerImages: UICollectionView!
    // MARK: - Variables
    
    var bannerImagesData  =  [[String:Any]]()
    var eventDetailData =  [String:Any]()
    var userList =  [[String:Any]]()

    var eventId:Int?
    
    
    override func viewDidLoad()
    {
      super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getPartyDetails()
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
          _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonJoinAction(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if button.title(for: .normal) == "Message" {
            
            if let tabBarController = UIApplication.shared.delegate?.window!!.rootViewController as? UITabBarController {
                   tabBarController.selectedIndex = 1
                AppDelegate.isChatcomingFrom = "events"
               }
        }else{
            self.joinPartywith(id: self.eventId!)
        }
    }
    
    
    // MARK: - API Calling
    func getPartyDetails()
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
    
       
        
        let parameters: [String: Any] = [
            "id" : self.eventId as? Any,
            "latitude":"-1.329717",
            "longitude":"36.82288610000001"
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "eventDetail"
        
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
                        { [self] in
                            
//
                            if let tempArray = t["event"] as? [String:Any]{
                                self.eventDetailData = tempArray
                                self.bannerImagesData = eventDetailData["event_benner_image"] as! [[String:Any]]
                                self.collectionBannerImages.reloadData()
                                if let dist = (self.eventDetailData["distance"] as? Double) {
                                    self.labelDistance.text = String(format: "%.2f", dist)
                                }
                                if let rating = self.eventDetailData["event_rating"] as? String {
                                    self.labelRattiing.text = rating
                                }
                                
                                if let isJoint = self.eventDetailData["is_join_event"] as? String{
                                    if isJoint == "yes" {
                                        self.buttonJoin.setTitle("Message", for: .normal)
                                    }else{
                                        self.buttonJoin.setTitle("Join", for: .normal)

                                    }
                                }
                                if let venue = self.eventDetailData["vanue_name"] as? String{
                                    self.labelTitle.text = venue
                                }
                                
                                if let usrList = self.eventDetailData["join_event_user_list"] as? [[String:Any]] {
                                    self.userList = usrList
                                    if usrList.isEmpty {
                                        self.labelNumberOfAttandee.text = "noone has joined yet"
                                    }else if usrList.count == 1{
                                        self.labelNumberOfAttandee.text = "1 person is going"
                                    }else{
                                        self.labelNumberOfAttandee.text = "\(usrList.count)" + " people are going"
                                                                }
                                    self.CollPartiesAtte.reloadData()
                                }
                                if let desc = self.eventDetailData["description"] as? String{
                                    self.textViewDescp.text = desc
                                }
                            }
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
    
    func joinPartywith(id:Int)
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
    
       
        
        let parameters: [String: Any] = [
            "event_id" : id,
            ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "joinEvent"
        
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
                    
                    let error = t["error"] as! String
                    print(error)
                    
                    if error == "false"
                    {
                        DispatchQueue.main.async
                        { [self] in
                            self.buttonJoin.setTitle("Message", for: .normal)
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
