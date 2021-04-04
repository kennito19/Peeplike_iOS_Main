//
//  UserProfileVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import AACarousel
import Kingfisher
import APESuperHUD
import Alamofire

class CategoryCell:UICollectionViewCell {
    
    @IBOutlet weak var labelTagStatus: UILabel!
    @IBOutlet weak var imageViewTag: UIImageView!
    
    
     override var intrinsicContentSize: CGSize {
         return CGSize(width: self.labelTagStatus.intrinsicContentSize.width + 40.0, height: 45.0)
     }
     
     override func awakeFromNib() {
         super.awakeFromNib()
     }
     
     func config(info: String) {
         self.labelTagStatus.text = info
     }
}

class UserProfileVC: UIViewController
{

    @IBOutlet weak var collectionCatogory: UICollectionView!
    @IBOutlet weak var profileImagesCollection: UICollectionView!

    // MARK: - IBOutlets
    @IBOutlet weak var cv: AACarousel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelStaus: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewMeetup: RoundableView!
    @IBOutlet weak var labeltRequestMeetup: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
    @IBOutlet weak var buttonMeetup: UIButton!

    // MARK: - Variables
    var imgs = ["1","2","3","4","5"]
    var titleArray = ["","","","",""]
    var userDetail = [String:Any]()
    var latString = ""
    var longString = ""
    var profileImages = [[String:Any]]()
    var userID:Int?
    var catgoryData = [[String:Any]]()
    var timer:Timer?
    var x = 1

    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        self.getUserDetailBy(id: self.userID!)
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collectionCatogory.collectionViewLayout = layout
        
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    
   @objc func scrollAutomatically(_ timer1: Timer) {
    self.profileImagesCollection.isPagingEnabled = false
            if let coll  = profileImagesCollection {
                for cell in coll.visibleCells {
                           let indexPath: IndexPath? = coll.indexPath(for: cell)
                           if ((indexPath?.row)! < profileImages.count - 1){
                               let indexPath1: IndexPath?
                               indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)

                               coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                           }
                           else{
                               let indexPath1: IndexPath?
                               indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                               coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                           }
                }
            }
    
    self.profileImagesCollection.isPagingEnabled = true

            
        }
    
    // MARK: - Button Action
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func userMeetUpAction(_ sender: Any) {
        
        self.sendMeetupRequestBy(id: self.userID!)
    }
    
    // MARK: - Private Method
    
    func getUserDetailBy(id:Int)
    {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
       
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
                            "Authorization": "Bearer " + "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
        let parameters: [String: Any] = [

            "user_id": id,
            "latitude" : self.latString,
            "longitude" : self.longString
        ]
        
        print("Delete Photo Parameters->",parameters)
        
        let url =  API.BASEURL + "usersProfileView"
        
        
        
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
                    let error_message = t["error_message"] as! String
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            self.userDetail = t["users"] as! [String:Any]
                            self.setUserDetails()
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast(error_message)
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
    
    func sendMeetupRequestBy(id:Int)
    {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
       
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
                            "Authorization": "Bearer " + "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
        let parameters: [String: Any] = [
            "user_id": id
        ]
        
        print("Delete Photo Parameters->",parameters)
        
        let url =  API.BASEURL + "sendUserMeetup"
        
        
        
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
                    let error_message = t["error_message"] as! String
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            self.view.makeToast(error_message)
                            self.getUserDetailBy(id: self.userID!)
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast(error_message)
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
    
    func setUserDetails() {
        
        self.labelUserName.text = self.userDetail["first_name"] as! String + " ," + "\(self.userDetail["age"] as! Int)"
        if let address = (self.userDetail["address"] as? String) {
            self.labelAddress.text = "Lives in " + address
        }
        
        if let status = self.userDetail["meetup_is_approve"] as? String {
            self.labeltRequestMeetup.text = status
            
            if status == "Request Meetup" {
                self.viewMeetup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
                self.buttonMeetup.isEnabled = true
            }else {
                self.viewMeetup.backgroundColor = .darkGray
                self.buttonMeetup.isEnabled = false

            }
            
        }
        
        self.labelLocation.text =  String(format: "%.2f", self.userDetail["distance"] as! Double) + " kilometers away"
        if let userStatusArray = self.userDetail["user_status"] as? [[String:Any]] {
            if !userStatusArray.isEmpty {
                self.labelStaus.text = (userStatusArray[0]["status_name"] as! String)
            }
        }
        if let profileImages = self.userDetail["profile_images"] as? [[String:Any]] {
//            profileImages.forEach { val in
//                image.append(val["image"] as! String)
//                names.append("\(val["id"] as! Int)")
//            }
            
            self.profileImages = profileImages
            self.profileImagesCollection.reloadData()
            self.timer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)


        }
            
            if let categoryArray = self.userDetail["category"] as? [[String:Any]] {
                if categoryArray.isEmpty {
                    self.catgoryData = categoryArray
                    self.collectionCatogory.reloadData()
                    self.collectionHeightConstraint.constant = 0
                }else{
                    
                    if categoryArray.count <= 2 {
                        self.collectionHeightConstraint.constant = 70
                    }
                    self.catgoryData = categoryArray
                    self.collectionCatogory.reloadData()
                }
            }
            
        
    }
}


extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.profileImagesCollection {
            return profileImages.count
        }
        return catgoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.profileImagesCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as! BannerImageCollectionViewCell
            let url = URL(string: profileImages[indexPath.row]["image"] as! String)
            cell.imageViewBanner.kf.setImage(with: url)
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let data = catgoryData[indexPath.item]
        cell.labelTagStatus.text = (data["category_name"] as! String)
        let str = data["category_image"] as! String
        let url = URL(string: str)
        cell.imageViewTag.kf.setImage(with: url)
        return cell
     }
    

}
