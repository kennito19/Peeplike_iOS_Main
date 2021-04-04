//
//  PartyTodayyCollectionViewCell.swift
//  Peepalike
//
//  Created by Rao, Bhavesh (external - Project) on 28/03/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class PartyTodayyCollectionViewCell: UICollectionViewCell {
        @IBOutlet weak var img: UIImageView!
        @IBOutlet weak var lblPartyName: UILabel!
        @IBOutlet weak var lblVenueName: UILabel!
        @IBOutlet weak var lblPartyEndTime: UILabel!
        @IBOutlet weak var lblPartyEndDate: UILabel!
        @IBOutlet weak var lblPartyEndMonth: UILabel!

    @IBOutlet weak var labelJoin: UILabel!
    
    @IBOutlet weak var buttonJoin: UIButton!
    
    @IBOutlet weak var labelUserCoount: UILabel!
}
