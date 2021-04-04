//
//  CollPeopleCell.swift
//  Peepalike
//
//  Created by MacBook on 21/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class CollPeopleCell: UICollectionViewCell
{
    @IBOutlet weak var vw: RoundableView!
    
    override func awakeFromNib()
    {
        vw.roundCorners(corners: [.bottomRight,.bottomLeft], radius: 10.0)
    }
    
}
