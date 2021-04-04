//
//  SearchResultVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
         let headerView = coll.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PackCollectionSectionView", for: indexPath) as? PackCollectionSectionView
        //
        if indexPath.section == 0
        {
             headerView!.lbl.text = "Recently Online"
        }
        else
        {
             headerView!.lbl.text = "Nearby"
        }
               
        
                return headerView!
    }
    

    // MARK: - IBOutlets
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
     @IBOutlet weak var coll: UICollectionView!
    
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func btnFilterAction(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            btnPersonal.backgroundColor = .white
            btnPersonal.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
           
        }
        else if sender.tag == 2
        {
            btnPersonal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnPersonal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnGroup.backgroundColor = .white
            btnGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
           
            
        }
    }

}
