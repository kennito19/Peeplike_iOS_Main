//
//  SettingVC.swift
//  Peepalike
//
//  Created by MacBook on 24/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import APESuperHUD
import Alamofire
import Kingfisher
import CoreLocation



class SettingVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
   
    
    // MARK:- get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType)
    {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
        {
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
            self.ImageUpload(filename: imageURL.path, fileImg: editedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
   
    
    @IBOutlet weak var buttonCamera: UIButton!
    
    
    @IBOutlet weak var distanceSlider: UISlider!

    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    
    @IBOutlet weak var labelMaxDistance: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var textFieldContactNumber: UITextField!
    // MARK: - IBOutlets
     @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var constraintScrollBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textViiew: UITextView!
    // MARK: - Variables
    var imgData = [String]()
    var profileImageData = [[String:Any]]()
    var imgUploadPara = ""
    var deletedImageId:Int!
    var user_details = NSDictionary()
    var address = ""
    
    var lat = ""
    var long = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GetUserProfile()
        self.coll.isUserInteractionEnabled = true
        self.coll.dragInteractionEnabled = true
        
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    fileprivate func recordItem(cordinator:UICollectionViewDropCoordinator,destinationIndexpath:IndexPath,collectionView:UICollectionView){
        if let item = cordinator.items.first,
           let sorucePath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.imgData.remove(at: sorucePath.item)
                self.imgData.insert(item.dragItem.localObject as! String, at: destinationIndexpath.item)
                collectionView.deleteItems(at: [sorucePath])
                collectionView.insertItems(at: [destinationIndexpath])
                
                let image = self.imgData[destinationIndexpath.item]
                let tmpArray = profileImageData.filter { value in
                    return value["image"] as! String == image
                }
                
                self.updateProfileImage(para: (tmpArray[0]["id"] as! Int))
                
            }, completion: nil)
            cordinator.drop(item.dragItem, toItemAt: destinationIndexpath)
        }
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {

        if self.constraintScrollBottom.constant == 0 {
            self.constraintScrollBottom.constant = 260
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        self.constraintScrollBottom.constant = 0
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
        
        textFieldEmail.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        textFieldEmail.resignFirstResponder()
        
    }
    
    @IBAction func buttonCameraAction(_ sender: Any) {
        print("You can Upload image", 1 )
        self.imgUploadPara = "image" + "1"
        print("Parameter of image:-",self.imgUploadPara)
        getImage(fromSourceType: .photoLibrary)

    }
    @IBAction func sliderValueChange(_ sender: Any) {
        let slider = sender as! UISlider
        let value = slider.value
        self.labelMaxDistance.text = "\(Int(value))" + "-KM"
}
    // MARK: - Button Action
    
    @IBAction func buttonLocationAciton(_ sender: Any) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "GoogleLocationViewController") as! GoogleLocationViewController
        ctrl.delegate = self
        self.present(ctrl, animated: true, completion: nil)
    }
    
    
    @IBAction func btnBackAction(_ sender: Any)
    {
          _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        self.view.endEditing(true)
        self.updateUserProfile()
    }
    @IBAction func btnLogoutAction(_ sender: Any)
    {
        LogoutApi()
    }
    
    @IBAction func selectgenderAction(_ sender: Any)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select gender", message: "", preferredStyle: .actionSheet)

           let cancelActionButton = UIAlertAction(title: "Male", style: .default) { _ in
            DispatchQueue.main.async {
                self.labelGender.text  = "Male"
            }
           }
           actionSheetControllerIOS8.addAction(cancelActionButton)

           let saveActionButton = UIAlertAction(title: "Female", style: .default)
               { _ in
            DispatchQueue.main.async {
                self.labelGender.text  = "Female"
            }
           }
           actionSheetControllerIOS8.addAction(saveActionButton)

           let deleteActionButton = UIAlertAction(title: "Both", style: .default)
               { _ in
            DispatchQueue.main.async {
                self.labelGender.text  = "Both"
            }
           }
           actionSheetControllerIOS8.addAction(deleteActionButton)
           self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    // MARK: - Api Calling
    
    
    
    func updateUserProfile()  {
        
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
        let tempArr = (self.labelMaxDistance.text!).components(separatedBy: "-")
        
        let parameters: [String: Any] = [
            
            "first_name" : self.user_details["first_name"] as! String,
            "last_name" : self.user_details["last_name"] as! String,
            "email":self.textFieldEmail.text!,
            "phone_number":self.textFieldContactNumber.text!,
            "age": (self.labelAge.text!),
            "address":   self.address,
            "gender":self.labelGender.text!,
            "max_distance":(tempArr[0]),
            "latitude":  self.lat,
            "longitude":self.long,
            "image":"",
            "description":self.textViiew.text!

        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "update_profile"
        
        
        
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
                            self.view.makeToast("success")
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast("failure")
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


    
    
//    func updateUserProfile()
//    {
//
//        DispatchQueue.main.async
//            {
//                APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
//        }
//
//
//
//
//        print("Adduser Parameters->",parameters)
//
//        let url =  API.BASEURL + "update_profile"
//
//
//        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
//            print(response.result)
//
//            DispatchQueue.main.async
//                {
//                    APESuperHUD.dismissAll(animated: true)
//            }
//
//            switch response.result {
//
//
//
//
//            case .success(_):
//                if let json = response.value
//                {
//                    //                    successHandler((json as! [String:AnyObject]))
//
//
//                    DispatchQueue.main.async
//                                  {
//                                      APESuperHUD.dismissAll(animated: true)
//                              }
//
//                    print(json)
//                    let t = json as! NSDictionary
//                    print(t)
//
//                    let success = t["error_message"] as! String
//
//
//                    let token = t["token"] as! String
//                    print("Auth token->",token)
//
//                    UserDefaults.standard.setValue(token, forKey: SESSION.authToken)
//
//                    if success == "success"
//                    {
//                        //go to home screen
//
//                        self.view.makeToast("success")
//                    }
//                    else
//                    {
//                        self.view.makeToast("Something went wrong!")
//                    }
//
////                    let t1 = t[0] as! NSDictionary
////                    print(t1)
////
////                    let statusCode = t1["statusCode"] as! NSNumber
////                    print(statusCode)
//
//
//
//
//
//
//                }
//                break
//            case .failure(let error):
//                //                failureHandler([error as Error])
//                print(error)
//                break
//            }
//        }
//    }
    
    
    func GetUserProfile()
    {
        self.imgData.removeAll()
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
                        { [self] in
                            
//                            self.GetContact()
                             user_details = t["user_details"] as! NSDictionary
                            if let age = user_details["age"] as? Int {
                                self.labelAge.text = "\(age)"

                            }
                            self.labelGender.text =  user_details["gender"] as? String
                            self.textFieldEmail.text = user_details["email"] as? String
                            if let phone_number = user_details["mobile"] as? String {
                                self.textFieldContactNumber.text =  phone_number
                            }else{
                                self.textFieldContactNumber.text = ""
                            }
                            
                            if let max_distance = user_details["max_distance"] as? String {
                                distanceSlider.value = Float(max_distance)!
                                self.labelMaxDistance.text = max_distance + "-KM"
                            }
                            
                            if let desc = user_details["description"] as? String {
                                self.textViiew.text = desc
                            }
                            
                            self.lat =  (user_details["latitude"] as? String)!
                            self.long =  (user_details["longitude"] as? String)!
                            self.getAddressFromLatLon(pdblLatitude: (user_details["latitude"] as? String)!, withLongitude:  (user_details["longitude"] as? String)!)
                            
                            print("User Details->",user_details)
                            if let imageArray = user_details["profile_images"] as? [[String:Any]] {
                                self.profileImageData = imageArray
                                if profileImageData.count < 10 {
                                    self.buttonCamera.isHidden = false
                                }else{
                                    self.buttonCamera.isHidden = true
                                }
                                imageArray.forEach { val in
                                    imgData.append(val["image"] as! String)
                                }
                            }
                            
                            print("Total Images->",self.imgData.count)
                            DispatchQueue.main.async
                            {
                                self.coll.reloadData()
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
    
    
    func LogoutApi()
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
        
        let url =  API.BASEURL + "logOut"
        
        
        
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
                            
                            let domain = Bundle.main.bundleIdentifier!
                            UserDefaults.standard.removePersistentDomain(forName: domain)
                            UserDefaults.standard.synchronize()
                            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                            
                            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignupVC") as? SignupVC
                            self.navigationController?.pushViewController(vc!, animated: true)
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
    
    func ImageUpload(filename:String,fileImg:UIImage)
    {
        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        
      
        
        
        
        let parameters = [ "foldername": "SG_Driver" ]
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
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            DispatchQueue.main.sync
            {
                    
                    print("imageview Name->",filename)
                    print("paraname->",fileImg)
                    multipartFormData.append((fileImg.jpegData(compressionQuality: 0.2))!, withName: "image", fileName: filename, mimeType: "image/png")
            }
            
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
        to:  API.BASEURL + "update_profile_image",
        method: .post,
        // headers: headers,
         headers: headers,
         encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print("the status code is :")
                
                upload.uploadProgress(closure: { (progress) in
                    print("something",progress)
                })
                
                upload.responseJSON { response in
                    print("the resopnse code is : \(response.response?.statusCode)")
                    print("the response is : \(response)")
                    
                    
                    if  response.result.isSuccess
                    {
                        let res = response.value as! NSDictionary
                        let error = res["error"] as! String
                        let error_message = res["error_message"] as! String
                        if error == "false"
                        {
                            DispatchQueue.main.async
                            {
                                self.GetUserProfile()
                                self.view.makeToast(error_message)
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
                    else
                    {
                        DispatchQueue.main.async
                        {
                            self.view.makeToast("Something Went Wrong!")
                        }
                    }
                    
                    
                    
                    DispatchQueue.main.async
                    {
                        APESuperHUD.dismissAll(animated: true)
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                break
            }
            
        })
        
        
    }
    
    func updateProfileImage(para:Int)
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

            "img_id": para
        ]
        
        print("Delete Photo Parameters->",parameters)
        
        let url =  API.BASEURL + "updateUserProfileImage"
        
        
        
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
//                            self.view.makeToast(error_message)
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
//                            self.view.makeToast(error_message)
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
    
    
    func DeleteImage(para:Int)
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

            "id": para
        ]
        
        print("Delete Photo Parameters->",parameters)
        
        let url =  API.BASEURL + "deleteProfileImage"
        
        
        
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
                            self.GetUserProfile()
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
                        
                        self.address = addressString
                        self.labelLocation.text = addressString
                    }
            })

        }
}

extension SettingVC {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = coll.dequeueReusableCell(withReuseIdentifier: "ProfileSettingCell", for: indexPath) as! ProfileSettingCell
        
        let ti = self.imgData.count
        let ti1 = ti - 1
        var ic = ""
        
        let ic1 = indexPath.row + 1
        ic = "image" + ic1.description
        print("Image->",ic)
        
        
        
        
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(DeleteAction(sender:)), for: .touchUpInside)

        
            if indexPath.row == ti
            {
                cell.img.borderColor = #colorLiteral(red: 0.3176470588, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
                cell.img.borderWidth = 1
                cell.imgCamera.alpha = 1
                cell.btn.alpha = 0
            }
            else
            {
                let tdata = self.imgData[indexPath.row]
//                let event_image = tdata[ic] as! String
                let url = URL(string: tdata)
                cell.img.kf.setImage(with: url)
//                cell.img.image = #imageLiteral(resourceName: "1")
                cell.imgCamera.alpha = 0
                cell.btn.alpha = 1
            }
        
        return cell
    }
    
    //MARK: - Cell Button Action 
    @objc func DeleteAction(sender: UIButton!)
    {
        let ic = sender.tag + 1
        self.imgUploadPara = "image" + ic.description
        print("Remove image number->",self.imgUploadPara)
        let image = self.imgData[sender.tag]
        let tmpArray = profileImageData.filter { value in
            return value["image"] as! String == image
        }
        
        self.DeleteImage(para: (tmpArray[0]["id"] as! Int))
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let ti = self.imgData.count
//        let ti1 = ti - 1
        let ic = indexPath.row + 1
        
            if indexPath.row == ti
            {
                print("Upload new image..")
                if ic > 10
                {
                    print("Maximum 10 image is done")
                }
                else
                {
                    print("You can Upload image",ic)
                    self.imgUploadPara = "image" + ic.description
                    print("Parameter of image:-",self.imgUploadPara)
                    getImage(fromSourceType: .photoLibrary)
                }
            }
            else
            {
               print("Do nothing")
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/3, height: 130)
    }
}
extension SettingVC : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            let image = imgData[indexPath.item]
            let itemProvide = NSItemProvider(object: image as NSString)
            let dragItme = UIDragItem(itemProvider: itemProvide)
            dragItme.localObject = image
            return [dragItme]
        
    }
}
    


extension SettingVC : UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexpath:IndexPath
        if let indexpath = coordinator.destinationIndexPath {
            destinationIndexpath = indexpath
        }else{
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexpath = IndexPath(item: row - 1, section: 0)
        
        }
        
        if coordinator.proposal.operation == .move {
            self.recordItem(cordinator: coordinator, destinationIndexpath: destinationIndexpath, collectionView: collectionView)
        }

    }
    
    

    
}

extension SettingVC:UserSelectedLocationDelegate{
    func userSelectedLocation(address: String, lat: Double, long: Double) {
        self.labelLocation.text = address
        self.lat = "\(lat)"
        self.long = "\(long)"
        
        
    }
}
