//
//  CustomPage.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class CustomPage: SwiftyOnboardPage {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        UIView.animate(withDuration: 5.0, delay: 0, options: [.repeat, .autoreverse], animations: {
        
            self.image.transform = CGAffineTransform(translationX: (-self.image.frame.width + 10) + self.bounds.width, y: 0)
        
                }, completion: nil)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
