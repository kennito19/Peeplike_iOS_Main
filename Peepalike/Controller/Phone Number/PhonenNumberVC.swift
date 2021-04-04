//
//  PhonenNumberVC.swift
//  Peepalike
//
//  Created by MacBook on 18/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CountryPickerView


class PhonenNumberVC: UIViewController
{

    // MARK: - IBOutlets
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var cpvMain: CountryPickerView!
    
    // MARK: - Variables
    let cpvInternal = CountryPickerView()
    var code = "+91"
    
    override func viewWillAppear(_ animated: Bool)
    {
        cpvMain.countryDetailsLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtPhoneNumber.keyboardType = .numberPad
        
        cpvInternal.delegate = self
        cpvMain.delegate = self
        
        cpvMain.showPhoneCodeInView = true
        cpvMain.showCountryCodeInView = true
        cpvMain.showCountryNameInView = false
        cpvMain.flagImageView.alpha = 0
        
    
        
        
//        PhoneAuthProvider.provider().verifyPhoneNumber("+918200539413", uiDelegate: nil)
//        {
//            (verificationID, error) in
//            if let error = error
//            {
//                print(error.localizedDescription)
//                return
//            }
//
//
//            print("Phone verification id:-",verificationID)
//            UserDefaults.standard.set(verificationID, forKey: SESSION.PhoneVerificaionID)
////            self.view.makeToast("OTP Send.")
//
//
//            if verificationID != nil
//            {
//
//            }
//
//        }
        
    }
    
    // MARK: - Button Action
    @IBAction func btnContinueAction(_ sender: Any)
    {
        
//        let verificationID = UserDefaults.standard.string(forKey: SESSION.PhoneVerificaionID)
//
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID!,
//            verificationCode: self.txtPhoneNumber.text!)
//
//        Auth.auth().signIn(with: credential)
//        { (authResult, error) in
//            if let error = error
//            {
//                print("Error ",error.localizedDescription)
////                self.view.makeToast(error.localizedDescription)
//                return
//            }
//            print("Signin done->")
//
//        }
        
        if self.txtPhoneNumber.text!.count <= 0
        {
            self.view.makeToast("Please enter Phone Number")
        }
        else
        {
            let finalPhne = self.code + self.txtPhoneNumber.text!
            print("Final Phone Number->",finalPhne)
            
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
            vc?.phoneNumber = finalPhne
            
            self.navigationController?.pushViewController(vc!, animated: true)

        }
        
        
    }
    
    // MARK:- Tap Action
    @IBAction func TapCountryPickerAction(_ sender: Any)
    {
        print("Tap Country Action..")
           cpvInternal.showCountriesList(from: self)
    }
    
    

    
}

extension PhonenNumberVC: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
    {
        
        print("calling 2")
            var countries = [Country]()
//            ["NG", "US", "GB"].forEach { code in
//                if let country = countryPickerView.getCountryByCode(code)
//                {
//                    print("calling 3")
//                    countries.append(country)
//                }
//            }
            return countries
        
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        
            return "Preferred title"
        
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool
    {
        print("Calling 1")
        return countryPickerView.tag == cpvMain.tag
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
//    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
//        if countryPickerView.tag == cpvMain.tag {
//            switch searchBarPosition.selectedSegmentIndex {
//            case 0: return .tableViewHeader
//            case 1: return .navigationBar
//            default: return .hidden
//            }
//        }
//        return .tableViewHeader
//    }
//
//    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
//        return countryPickerView.tag == cpvMain.tag && showPhoneCodeInList.isOn
//    }
//
//    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
//        return countryPickerView.tag == cpvMain.tag && showCountryCodeInList.isOn
//    }
}

extension PhonenNumberVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        self.code = country.phoneCode
        
        print(title,"\n---------------\n",message)
//        self.txtCountryCode.text = country.phoneCode
        
        
        // showAlert(title: title, message: message)
    }
    
  
}
