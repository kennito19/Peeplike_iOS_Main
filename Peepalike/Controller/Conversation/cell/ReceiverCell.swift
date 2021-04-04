//
//  ReceiverCell.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var vw: UIView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        vw.roundCorners(corners: [.topRight, .bottomLeft, .bottomRight], radius: 20.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
