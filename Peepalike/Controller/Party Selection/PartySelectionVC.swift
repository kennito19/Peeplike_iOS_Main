//
//  PartySelectionVC.swift
//  Peepalike
//
//  Created by MacBook on 18/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import TagListView
import APESuperHUD
import Alamofire

class PartySelectionVC: UIViewController,TagListViewDelegate
{

    // MARK: - IBOutlets
    @IBOutlet weak var vw1: RoundableView!
    @IBOutlet weak var vw2: RoundableView!
    @IBOutlet weak var vw3: RoundableView!
    @IBOutlet weak var vw4: RoundableView!
    @IBOutlet weak var vw5: RoundableView!
    @IBOutlet weak var vw6: RoundableView!
    @IBOutlet weak var vw7: RoundableView!
    @IBOutlet weak var vw8: RoundableView!
    @IBOutlet weak var vw9: RoundableView!
    @IBOutlet weak var vw10: RoundableView!
    @IBOutlet weak var vw11: RoundableView!
    @IBOutlet weak var vw12: RoundableView!
    @IBOutlet weak var vw13: RoundableView!
    @IBOutlet weak var vw14: RoundableView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl8: UILabel!
    @IBOutlet weak var lbl9: UILabel!
    @IBOutlet weak var lbl10: UILabel!
    @IBOutlet weak var lbl11: UILabel!
    @IBOutlet weak var lbl12: UILabel!
    @IBOutlet weak var lbl13: UILabel!
    @IBOutlet weak var lbl14: UILabel!
    
    // MARK: - Variables
    @IBOutlet weak var tagView: TagListView!
    
    var ArrCatname = [String]()
    var ArrCatID = [String]()
    var SelCatID = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Home Cleaning
        tagView.alignment = .left
        tagView.addTags(["Add", "two", "tags","Home Cleaning","Home Cleaning","Home Cleaning","Home Cleaning","Home Cleaning","Home Cleaning"])
        tagView.delegate = self
        
        GetCat()
        
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        
        let indexOfA = self.ArrCatname.firstIndex(of: title)
        print("Selected cat index->",indexOfA)
        let indexofID = self.ArrCatID[indexOfA!]
       print("Selected cat Id->",indexofID)
        
        if SelCatID.contains(indexofID)
        {
            print("yes")
            let farray = SelCatID.filter {$0 != indexofID}
            self.SelCatID = farray
        }
        else
        {
            print("No")
            self.SelCatID.append(indexofID)
        }
        
        print("Selcted array->",self.SelCatID)
        
    }
    
    
    
    
    
    // MARK: - Button Action
    @IBAction func btnSelectioActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            lbl1.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw1.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 2
        {
            lbl2.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw2.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 3
        {
            lbl3.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw3.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 4
        {
            lbl4.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw4.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 5
        {
            lbl5.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw5.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 6
        {
            lbl6.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw6.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 7
        {
            lbl7.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw7.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 8
        {
            lbl8.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw8.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 9
        {
            lbl9.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw9.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 10
        {
            lbl10.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw10.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 11
        {
            lbl11.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw11.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 12
        {
            lbl12.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw12.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 13
        {
            lbl13.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw13.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        else if sender.tag == 14
        {
            lbl14.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            vw14.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        }
        
    }
    
    @IBAction func btnSelectAction(_ sender: Any)
    {
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(vc, animated: true)
//
        if self.SelCatID.count < 3
        {
            self.view.makeToast("please select atleast 3")
        }
        else
        {
            UpdateCat()
        }
        
//        let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPhotosVC") as! AddPhotosVC
//        self.navigationController?.pushViewController(vc, animated: true)

        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab")
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - API Calling
    func UpdateCat()
    {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
        let provider_id = UserDefaults.standard.string(forKey: "provider_id")
        print("provider_id->",provider_id)
        
        let tokn = UserDefaults.standard.string(forKey: SESSION.authToken)
        print("Auth token->",tokn)
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
        
        let catidStr = self.SelCatID.joined(separator: ",")
        print(catidStr)
    
       
        
        let parameters: [String: String] = [

            "category_id": catidStr,
            
        ]
        
        print("Update Cat Parameters->",parameters)
        
        let url =  API.BASEURL + "update_category"
        
        
        
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
                           
                            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPhotosVC") as! AddPhotosVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast("Something went wrong!")
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
    
    
    func GetCat()
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
                            "Authorization": "Bearer " + "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//        let parameters: [String: String] = [
//
//            "user_id": provider_id!,
//            "id":Cid
//        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "category_list"
        
        
        
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
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
                            let category = t["category"] as! NSArray
                            
                            for i in category
                            {
                                let t1 = i as! NSDictionary
                                let category_name = t1["category_name"] as! String
                                let id = t1["id"] as! NSNumber
                                self.ArrCatname.append(category_name)
                                self.ArrCatID.append(id.description)
                            }
                            
                            self.tagView.removeAllTags()
                            self.tagView.addTags(self.ArrCatname)
//
                            
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast("Something went wrong!")
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
