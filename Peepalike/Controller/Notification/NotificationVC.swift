//
//  NotificationVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        return cell
    }
    

    // MARK: - IBOutlets
    @IBOutlet weak var tbl: UITableView!
    
    // MARK: - Variables
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action

}
