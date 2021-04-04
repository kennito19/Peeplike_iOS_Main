//
//  OnBoardContentViewController.swift
//  UberdooX
//
//  Created by Karthik Sakthivel on 12/10/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit

class OnBoardContentViewController: UIViewController
{

//    static var storyBoardId: String = ViewIdentifiers.OnBoardContentViewController
//    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var firstPageLogo: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var firstPageContent: UILabel!
    @IBOutlet weak var firstPageTitle: UILabel!
    @IBOutlet weak var otherPageTitle: UILabel!
    @IBOutlet weak var otherPageContent: UILabel!
    
    @IBOutlet weak var logoView: UIView!
    var pageIndex :Int!
    var pageTitle :String!
    var pageContent :String!
    var imageContent : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
        if(pageIndex == 0)
        {
            logoView.isHidden = false
            firstPageTitle.isHidden = false
            firstPageContent.isHidden = false
            otherPageTitle.isHidden = true
            otherPageContent.isHidden = true
        }
        else{
            logoView.isHidden = true
            firstPageTitle.isHidden = true
            firstPageContent.isHidden = true
            otherPageTitle.isHidden = false
            otherPageContent.isHidden = false
        }
        self.backgroundImage.image = UIImage(named: self.imageContent)
        self.firstPageTitle.text = self.pageTitle
        self.otherPageTitle.text = self.pageTitle
        self.firstPageContent.text = self.pageContent
        self.otherPageContent.text = self.pageContent
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
