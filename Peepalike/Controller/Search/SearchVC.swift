//
//  SearchVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class SearchVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
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
        
        return CGSize(width: collectionViewSize/3, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
//        vc?.hidesBottomBarWhenPushed = false
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 5
//    }
    // MARK: - IBOutlets
    @IBOutlet weak var coll: UICollectionView!
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    // MARK: - Variables
    
    var serchBarHeight = -1.0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let nib = UINib(nibName: "SearchCell", bundle: nil)
//        coll.register(nib, forCellWithReuseIdentifier: "SearchCell")
        if serchBarHeight != -1.0 {
            searchBarHeight.constant = CGFloat(serchBarHeight)
        }
    }
    
    @IBAction func txtSearchDidEnd(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    // MARK: - Button Action

}
