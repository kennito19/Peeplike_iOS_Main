//
//  MessageVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isgroup == true
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GroupConversationVC") as? GroupConversationVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConversationVC") as? ConversationVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
  
    @IBOutlet weak var btnEvent: UIButton!
    
    // MARK: - Variables
    var data = [1,2,3,4,5]
    var isgroup = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttoonPartingNowViewAllAciton(_ sender: Any) {
    }
    // MARK: - Button Action
    @IBAction func buttonUpcomingPartyViewAllAction(_ sender: Any) {
    }
    
   
    @IBAction func buttonMeetupViewAllAction(_ sender: Any) {
    }
    
    @IBAction func buttonPartyTodayViewALLAction(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppDelegate.isChatcomingFrom == "events" {
            btnEvent.backgroundColor = .white
            btnEvent.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnPersonal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnPersonal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            data = [1,2]
            tbl.reloadData()
            isgroup = false
        }else if AppDelegate.isChatcomingFrom == "group" {
            btnPersonal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            
            btnPersonal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnGroup.backgroundColor = .white
            btnGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            data = [1,2,3]
             tbl.reloadData()
            isgroup = true
        }

    }
    
    
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            btnPersonal.backgroundColor = .white
            btnPersonal.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            data = [1,2,3,4,5]
            tbl.reloadData()
            isgroup = false
        }
        else if sender.tag == 2
        {
            btnPersonal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnPersonal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnGroup.backgroundColor = .white
            btnGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            data = [1,2,3]
             tbl.reloadData()
            isgroup = true
            
        }else{
            
            btnEvent.backgroundColor = .white
            btnEvent.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            btnGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnPersonal.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            btnPersonal.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            data = [1,2]
            tbl.reloadData()
            isgroup = false
            
            
        }
    }
    

}
