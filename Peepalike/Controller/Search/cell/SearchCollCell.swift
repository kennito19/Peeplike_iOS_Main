//
//  SearchCollCell.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class SearchCollCell: UICollectionViewCell {
    @IBOutlet weak var imageViewUserProfile: RoundableImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var imageViewWifi: UIImageView!
    
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewOnlineStatus: RoundableView!
}
