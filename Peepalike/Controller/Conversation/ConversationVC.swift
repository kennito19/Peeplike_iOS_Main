//
//  ConversationVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row % 2 == 0
        {
            let cell = tbl.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            return cell
        }
        else
        {
            let cell = tbl.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            return cell
        }
        
        
    }
    

   
    // MARK: - IBOutlets
    @IBOutlet weak var tbl: UITableView!
    
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)

    }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
