//
//  VenueCell.swift
//  Peepalike
//
//  Created by MacBook on 22/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
    @IBOutlet weak var labelVenue: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    
    @IBOutlet weak var buttonStar: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonStarAction(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
