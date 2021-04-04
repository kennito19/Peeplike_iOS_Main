//
//  ChooseVenueVC.swift
//  Peepalike
//
//  Created by MacBook on 22/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import CoreLocation
import APESuperHUD
import Alamofire
class ChooseVenueVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
            
        cell.labelVenue.text = (locationList[indexPath.row]["address_line_1"] as! String)
        
        let lat = locationList[indexPath.row]["latitude"] as! Double
        let long = locationList[indexPath.row]["longitude"] as! Double
        
        let locationOne = CLLocation(latitude: lat, longitude: long)
        let locationTwo = CLLocation(latitude: CLLocationDegrees(Float(self.latString!)!), longitude: CLLocationDegrees(Float(self.longString!)!))

       let distance = locationOne.distance(from: locationTwo) * 0.000621371
        cell.labelDistance.text = String(format: "%.2f", distance) + " KM away"
        cell.buttonStar.tag = indexPath.row
        cell.buttonStar.addTarget(self, action: #selector(self.addFavAction), for: .touchUpInside)
        
        if let isFav = locationList[indexPath.row]["is_favorite"] as? String {
            if isFav == "no"{
                cell.buttonStar.isSelected = false
            }else{
                cell.buttonStar.isSelected = true

            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteLocation(id: self.locationList[indexPath.row]["id"] as! Int)
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - IBOutlets
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var labelStaus: UILabel!
    @IBOutlet weak var labelUserName: UILabel!

    var locations = [String]()
    var distance = [String]()
    var locationList = [NSDictionary]()
    var latString: String?
    var longString:String?
    var pofileImge:UIImage?
    var staus:String?
    var username:String?
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        imgClose.image = imgClose.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        imgClose.tintColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
//
        imgClose.image = pofileImge
        self.labelStaus.text = staus
        self.labelUserName.text = username
        #if targetEnvironment(simulator)
        self.latString = "-1.4307641240010585"
        self.longString = "36.978415150080714"
        #else
        print("dev")
        #endif
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getAllLocation()
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
          _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLocaitonAction(_ sender: Any)
    {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "GoogleLocationViewController") as! GoogleLocationViewController
        ctrl.delegate = self
        self.present(ctrl, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latString = "\(locValue.latitude)"
        self.longString = "\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        

    }
    
    // MARK: - Priavte Method
    
    @objc func addFavAction(sender:UIButton){
        var isFav = ""
        if sender.isSelected {
            isFav = "yes"
        }else{
            isFav = "no"
        }
        let data = self.locationList[sender.tag]
        self.addFav(id: data["id"] as! Int, is_favorite: isFav)
        
    }
    
    
    
    func getAllLocation(){
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
        
            
    //        print("Delete Contact Parameters->",parameters)
            
            let url =  API.BASEURL + "usersLocationList"
            
        Alamofire.request(url, method: .post ,parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
                
                print(response.result)
                
    //            SwiftSpinner.hide()
                
                              
                     
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
                                
                                
                                DispatchQueue.main.async
                                {
                                    APESuperHUD.dismissAll(animated: true)
                                }
                                self.locationList.removeAll()

    //
                               if let groups = t["address"] as? NSArray
                               {
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.locationList.append(t)
                                    self.tbl.reloadData()
                                }
                               }
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async
                                {
                                DispatchQueue.main.async
                                {
                                    APESuperHUD.dismissAll(animated: true)
                                }
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
    
    func addFav(id:Int,is_favorite:String)
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
            "id" : id as Any,
            "is_favorite" : is_favorite,
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "addFavUsersLocation"
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
            
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
                            
                            APESuperHUD.dismissAll(animated: true)
                            self.view.makeToast("Success")
                            self.getAllLocation()
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

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
    
    func deleteLocation(id:Int)
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
            "id" : id as Any,
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "deleteUsersLocation"
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
            
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
                        
                            APESuperHUD.dismissAll(animated: true)
                            self.view.makeToast("Success")
                            self.getAllLocation()
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

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
    
    func addLocation(address:String,lat:String,long:String)
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
        let parameters: [String: String] = [
            "address" : address,
            "latitude" : lat,
            "longitude" : long
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "addUserLocation"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
            
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
                            
                            APESuperHUD.dismissAll(animated: true)
                            self.view.makeToast("Success")
                            self.getAllLocation()
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

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

extension ChooseVenueVC : UserSelectedLocationDelegate
{
    func userSelectedLocation(address: String, lat: Double, long: Double) {
        self.locations.append(address)

        self.addLocation(address: address, lat: "\(lat)", long: "\(long)")
        
    }
}
