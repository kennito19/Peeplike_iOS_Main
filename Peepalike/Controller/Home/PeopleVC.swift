//
//  PeopleVC.swift
//  Peepalike
//
//  Created by Rao, Bhavesh (external - Project) on 31/03/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import APESuperHUD
import Alamofire
import Kingfisher
import CoreLocation

class PeopleVC: UIViewController {
   
@IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var buttonNearyBy: UIButton!
    @IBOutlet weak var buttonPopular: UIButton!
    @IBOutlet weak var imageViewPeopleNoData: UIImageView!

    var latString = ""
    var longString = ""
    var tag = 1
    @objc var refreshControl = UIRefreshControl()

    var userData = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nearByUserData()
        
        buttonNearyBy.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        buttonNearyBy.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        buttonPopular.backgroundColor = .white
        buttonPopular.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)

        self.imageViewPeopleNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))

        self.imageViewPeopleNoData.isHidden  = true

        self.refreshControl.addTarget(self, action: #selector(self.refreshCollection), for: UIControl.Event.valueChanged)
        self.coll.refreshControl  = self.refreshControl
        // Do any additional setup after loading the view.
    }
    
    
        
    // MARK: - User Action

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            buttonNearyBy.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            buttonNearyBy.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            buttonPopular.backgroundColor = .white
            buttonPopular.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            tag  = 1
            self.nearByUserData()

        }
        else if sender.tag == 2
        {
            tag  = 2
            buttonNearyBy.backgroundColor = .white
            buttonNearyBy.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            buttonPopular.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            buttonPopular.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            self.popularUserData()
            
        }
    }
    
    @IBAction func btnFilterAction(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    // MARK: - Priavte Method
    
    @objc func refreshCollection(){
        if tag == 1 {
            self.nearByUserData()
        }else{
            self.popularUserData()
        }
        refreshControl.endRefreshing()
    }

    func nearByUserData()  {
        
        self.userData.removeAll()
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
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "nearByUsersList"
        
        
        
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
                            let groups = t["users"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageViewPeopleNoData.isHidden = false
                            }else{
                                self.imageViewPeopleNoData.isHidden = true
                            }
                            
                            for i in groups
                            {
                                let t = i as! NSDictionary
                                self.userData.append(t)
                            }
                            self.coll.reloadData()
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
    
    func popularUserData()  {
        
        self.userData.removeAll()
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
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "populerUsersList"
        
        
        
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
                            let groups = t["users"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageViewPeopleNoData.isHidden = false
                            }else{
                                self.imageViewPeopleNoData.isHidden = true
                            }
                            
                            for i in groups
                            {
                                let t = i as! NSDictionary
                                self.userData.append(t)
                            }
                            self.coll.reloadData()
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




extension PeopleVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return userData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = coll.dequeueReusableCell(withReuseIdentifier: "SearchCollCell", for: indexPath) as! SearchCollCell
        let data = self.userData[indexPath.row]
        if let imaeg = data["image"] as? String{
            if !imaeg.isEmpty{
                let url = URL(string: imaeg)
                if url != nil {
                    cell.imageViewUserProfile.kf.setImage(with: url)
                }else{
                    cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
                }
            }else{
                cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
            }
        }else{
            cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
        }
        cell.labelName.text = (data["first_name"] as! String)
        
        let distance = data["distance"] as! NSNumber
        let tt = distance as! Double
        let doubleStr = String(format: "%.2f", tt)
        cell.labelStatus.text = doubleStr + " KM"
        
        if let isOnline = (data["isOnline"] as? String) {
            if isOnline == "online" {
                cell.viewOnlineStatus.backgroundColor = .systemGreen
            }else{
                cell.viewOnlineStatus.backgroundColor = .systemGray
            }
        }
        
        if let gender = (data["gender"] as? String) {
            if gender == "male"{
                cell.labelGender.text = "M"
            }else{
                cell.labelGender.text = "F"
            }
        }
        
        if let age = (data["age"] as? Int) {
            cell.labelAge.text = "\(age)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/3, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
        let data  =  userData[indexPath.item]
        vc?.userID = data["id"] as? Int
        vc?.latString = self.latString
        vc?.longString = self.longString
        vc?.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
