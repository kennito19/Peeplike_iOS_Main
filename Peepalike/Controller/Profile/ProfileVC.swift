//
//  ProfileVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD
import CoreLocation

class ProfileVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate
{
    
    private let kCellheaderReuse : String = "PackHeader"

    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        let headerView = coll.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PackCollectionSectionView", for: indexPath) as? PackCollectionSectionView
//
//        headerView!.lbl.text = "working"
//
//        return headerView!
//
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: self.view.layer.frame.width, height: 50)
//    }
    
    
    

    @IBOutlet weak var labelUserStatus: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var btnLocal: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgSetting: UIImageView!
    @IBOutlet weak var vwLocal: UIView!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewVenue: UITextView!

    @IBOutlet weak var imageViewProfile: RoundableImageView!
    @IBOutlet weak var labelLocation: UILabel!
    // MARK: - Variables
    let locationManager = CLLocationManager()
    var latString = ""
    var longString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgSetting.image = imgSetting.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgSetting.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        vwLocal.alpha = 1
        vwStatus.alpha = 0
        self.coll.register(PackCollectionSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellheaderReuse)  // UICollectionReusableView
        
        textView.textColor = .lightGray
        textView.text = "whats in your mind...?"
        textView.delegate = self
        
        textViewVenue.textColor = .lightGray
        textViewVenue.text = "Meetup status.."
        textViewVenue.delegate = self
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latString = "\(locValue.latitude)"
        self.longString = "\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.getAddressFromLatLon(pdblLatitude: (self.latString), withLongitude:  (self.longString))

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        GetUserProfile()

    }
    
    // MARK: - Button Action
    @IBAction func btnSettingAction(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingVC") as? SettingVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnChooseStatus(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseStatusVC") as? ChooseStatusVC
        vc?.userName = self.lblFullName.text!
        vc?.image = self.imageViewProfile.image
        vc?.status = self.labelUserStatus.text!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnChooseVenueAction(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseVenueVC") as? ChooseVenueVC
        vc?.pofileImge = self.imageViewProfile.image
        vc?.staus  = self.labelUserStatus.text
        vc?.username = self.lblFullName.text
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            btnLocal.backgroundColor = .white
            btnLocal.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnStatus.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnStatus.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            vwLocal.alpha = 1
            vwStatus.alpha = 0
           
        }
        else if sender.tag == 2
        {
            btnLocal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnLocal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnStatus.backgroundColor = .white
            btnStatus.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            vwLocal.alpha = 0
            vwStatus.alpha = 1
            
        }
    }
    
    // MARK:- API Calling
    func GetUserProfile()
    {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
        let provider_id = UserDefaults.standard.string(forKey: "provider_id")
        print("provider_id->",provider_id)
        
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
    
       
        
//        let parameters: [String: String] = [
//
//            "user_id": provider_id!,
//            "id":Cid
//        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "view_profile"
        
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
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
                            
//                            self.GetContact()
                            let user_details = t["user_details"] as! NSDictionary
                            
                            let first_name = user_details["first_name"] as! String
                            let last_name = user_details["last_name"] as! String
                            self.lblFullName.text = first_name + " " + last_name
                            
                            if let imaeg = user_details["image"] as? String{
                                if !imaeg.isEmpty{
                                    let url = URL(string: imaeg)
                                    if url != nil {
                                        self.imageViewProfile.kf.setImage(with: url)
                                    }else{
                                        self.imageViewProfile.image = UIImage(named: "defaultUser")
                                    }
                                }else{
                                    self.imageViewProfile.image = UIImage(named: "defaultUser")
                                }
                            }else{
                                self.imageViewProfile.image = UIImage(named: "defaultUser")
                            }
                            
//                            if let imageArray = user_details["profile_images"] as? [String] {
//                                if !imageArray.isEmpty {
//                                    if url != nil {
//                                    }else{
//                                        if let str = imageArray[1] as? String{
//                                            let url = URL(string: str)
//                                            self.imageViewProfile.kf.setImage(with: url)
//
//                                        }
//
//                                    }
//                                }
//                            }
                            if let userStatusArray = user_details["user_status"] as? [[String:Any]] {
                                if !userStatusArray.isEmpty {
                                    self.labelUserStatus.text = (userStatusArray[0]["status_name"] as! String)
                                }
                            }
//                            self.getAddressFromLatLon(pdblLatitude: , withLongitude:  (user_details["longitude"] as? String)!)

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

    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                        self.labelLocation.text = addressString
                    }
            })

        }

}

extension ProfileVC: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {
            textView.text = "whats in your mind...?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.isTranslucent = true
        
        doneToolbar.backgroundColor = .clear
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        textView.resignFirstResponder()
        
    }
    
}

extension ProfileVC {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        return 2
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = coll.dequeueReusableCell(withReuseIdentifier: "SearchCollCell", for: indexPath) as! SearchCollCell
        
        cell.imageViewUserProfile.image = #imageLiteral(resourceName: "5f54e1f71f076")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  10
         let collectionViewSize = collectionView.frame.size.width - padding
         
         return CGSize(width: collectionViewSize/3, height: 150)
    }
}


