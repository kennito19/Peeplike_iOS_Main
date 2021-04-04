//
//  AddPhotosVC.swift
//  Peepalike
//
//  Created by MacBook on 27/02/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class AddPhotosVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    // MARK: - IBOutlets
    @IBOutlet weak var btnContinue: customButton!
    
    // MARK: - Variables
   
    @IBOutlet weak var img1: UIImageView!

    var img11 = false
 
    var imageName:String?
    var imagePath:String?
    var ImgCount = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnContinue.isEnabled = false
        btnContinue.backgroundColor = .lightGray
        img1.contentMode = .scaleAspectFit
        

    }

    
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("Did cancel called..",self.ImgCount)
        self.ImgCount = self.ImgCount - 1
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
        {
            
            self.img1.image = editedImage
            let url = info[UIImagePickerController.InfoKey.imageURL] as? URL
            self.imagePath = url!.path
            self.imageName = url!.path
            
            btnContinue.isEnabled = true
            btnContinue.backgroundColor = #colorLiteral(red: 0.3157408237, green: 0.7599398494, blue: 0.8355919719, alpha: 1)

        
        picker.dismiss(animated: true, completion: nil)
    }
        
    }
    
    // MARK: - Button Action
    @IBAction func btnActions(_ sender: UIButton)
    {
        getImage(fromSourceType: .photoLibrary)

    }
    
    @IBAction func btnContinueAction(_ sender: Any)
    {
//        DispatchQueue.main.async {
//            APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
//        }
//        self.perform(#selector(imgUp), with: nil, afterDelay: 2.0)
        
        self.ImageUpload()
    }
    
  
    
    
    // MARK:- API Calling
    func ImageUpload()
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

        Alamofire.upload(multipartFormData: { [self] (multipartFormData) in
            DispatchQueue.main.sync
            {
          
                multipartFormData.append((img1.image!.jpegData(compressionQuality: 0.2))!, withName: "image", fileName: self.imageName!, mimeType: "image/png")

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
                        if error == "false"
                        {
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTab") as? MainTabController


                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        else
                        {
                            let error_message = res["error_message"] as! String
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

}
