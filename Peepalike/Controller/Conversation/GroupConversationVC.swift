//
//  GroupConversationVC.swift
//  Peepalike
//
//  Created by MacBook on 25/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class GroupConversationVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource
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
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = CollPartiesAtte.dequeueReusableCell(withReuseIdentifier: "PartyDetailsCell", for: indexPath) as! PartyDetailsCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CGSize(width: 60, height: 60)
    }
    // MARK: - IBOutlets
    @IBOutlet weak var CollPartiesAtte: UICollectionView!
     @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var vwType: UIView!
    
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vwType.roundCorners(corners: [.topRight, .topLeft], radius: 15.0)
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
          _ = navigationController?.popViewController(animated: true)
    }
   
}
