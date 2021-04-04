//
//  MeetupGroupCollectioCell.swift
//  Peepalike
//
//  Created by Rao, Bhavesh (external - Project) on 03/04/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class MeetupImageCell:UICollectionViewCell {
    
    @IBOutlet weak var imageViewUser: UIImageView!
    
    override  func awakeFromNib() {
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.bounds.width / 2
        self.imageViewUser.clipsToBounds = true
    }
}

class MeetupGroupCollectioCell: UICollectionViewCell {
    @IBOutlet weak var imageViewUser1: UIImageView!
    
    @IBOutlet weak var labelStaus: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageViewUser2: UIImageView!
    var users = [[String:Any]]()
    override  func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}
extension MeetupGroupCollectioCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetupImageCell", for: indexPath) as! MeetupImageCell
        cell.imageViewUser.image = UIImage(named: "defaultUser")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
}
