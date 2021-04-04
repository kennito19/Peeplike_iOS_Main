//
//  FilterVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class FilterVC: UIViewController
{

    
    // MARK: - IBOutlets
    
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Button Action
    @IBAction func btnBackction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)

    }
    

}
