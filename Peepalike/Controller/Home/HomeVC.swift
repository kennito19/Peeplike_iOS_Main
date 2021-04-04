//
//  HomeVC.swift
//  Peepalike
//
//  Created by MacBook on 20/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import AACarousel
import DropDown
import APESuperHUD
import Alamofire
import Kingfisher
import CoreLocation

class HomeVC: UIViewController,AACarouselDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate
{
   
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int)
    {
        
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int)
    {
        
    }
    
    func downloadImages(_ url: String, _ index: Int)
    {
        self.cv.images[index] = UIImage(named: self.imgs[index])!
    }
    @IBOutlet weak var imageVIewNearYouNoData: UIImageView!
    @IBOutlet weak var imageVIewTrendingEventNoData: UIImageView!
    @IBOutlet weak var imageViewPartingNowNoData: UIImageView!
    
    @IBOutlet weak var imgVwMeetupGroupNoData: UIImageView!

    @IBOutlet weak var imageViewMeetupGroupNoData: UIImageView!
    @IBOutlet weak var imageViewPreviousPartyNoData: UIImageView!
    @IBOutlet weak var imageViewHangoutUpcomingNoDtata: UIImageView!
    @IBOutlet weak var imageViewUpcomingExploreNoData: UIImageView!
    @IBOutlet weak var imageViewPartyTodayNoData: UIImageView!
    @IBOutlet weak var constraintPreviousHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewHangoutContainrHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightContainerView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightPartyNearYou: NSLayoutConstraint!
    // MARK: - IBOutlets
    
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var scrollViewParties: UIScrollView!
    @IBOutlet weak var scroollViewExplor: UIScrollView!
    @IBOutlet weak var buttonEvent: UIButton!
    
    @IBOutlet weak var buttonGroup: UIButton!
    
    @IBOutlet weak var scrollViewHangouts: UIScrollView!
    @IBOutlet weak var vwInvisible: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vwExplore: UIView!
    @IBOutlet weak var vwPeople: UIView!
    @IBOutlet weak var vwParties: UIView!
    @IBOutlet weak var vwHangouts: UIView!
    @IBOutlet weak var vwGroups: UIView!
    @IBOutlet weak var vwEvents: UIView!
    
    @IBOutlet weak var cv: AACarousel!
    @IBOutlet weak var CollPartiesToday: UICollectionView!
    @IBOutlet weak var CollPartyingNow: UICollectionView!
    @IBOutlet weak var CollExplore: UICollectionView!
    @IBOutlet weak var vwVisible: UIView!
    @IBOutlet weak var CollPartiesTrending: UICollectionView!
    @IBOutlet weak var CollPartiesNearYou: UICollectionView!
    @IBOutlet weak var CollPreviousParties: UICollectionView!
    @IBOutlet weak var CollUpcomingPartiesHangouts: UICollectionView!
    @IBOutlet weak var CollPeople: UICollectionView!
    @IBOutlet weak var collMeetupGroups: UICollectionView!
    
    @IBOutlet weak var lblDropDown: UILabel!
    @IBOutlet weak var vwDD: RoundableView!
    
    
    // MARK: - Variables
    let dropDown = DropDown()
    var imgs = ["1","2","3","4","5"]
    var titleArray = ["","","","",""]
    let pathArray = ["http://www.gettyimages.ca/gi-resources/images/Embed/new/embed2.jpg",
    "https://ak.picdn.net/assets/cms/97e1dd3f8a3ecb81356fe754a1a113f31b6dbfd4-stock-photo-photo-of-a-common-kingfisher-alcedo-atthis-adult-male-perched-on-a-lichen-covered-branch-107647640.jpg",
    "https://imgct2.aeplcdn.com/img/800x600/car-data/big/honda-amaze-image-12749.png",
    "http://www.conversion-uplift.co.uk/wp-content/uploads/2016/09/Lamborghini-Huracan-Image-672x372.jpg",
    "very-large-flamingo"]
    var PreviousPartyData = [NSDictionary]()
    var UpcomingPartyDataExplore = [NSDictionary]()
    var upcomingPartyDataHangouts = [NSDictionary]()

    var partyNearYouData = [NSDictionary]()
    var todayPartyData = [NSDictionary]()
    var trendingPartyData = [NSDictionary]()
    var partingNowUserData = [NSDictionary]()
    var currentSelectedTab = 1
    var timer:Timer?
    @objc var refreshControlParties = UIRefreshControl()
    @objc var refreshControlExplor = UIRefreshControl()
    @objc var refreshControlhangouts = UIRefreshControl()
    var latString = ""
    var longString = ""
    let locationManager = CLLocationManager()

    @IBOutlet weak var labelTempLocation: UILabel!
    func setupDD()
    {
        // The view to which the drop down will appear on
        dropDown.anchorView = vwDD // UIView or UIBarButtonItem
        DropDown.appearance().backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        DropDown.appearance().textColor = UIColor.white

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Kenya", "Oman", "India","Indonesia","USA"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.lblDropDown.text = item
        }

        // Will set a custom width instead of the anchor view width
//        dropDownLeft.width = 200
    }
    
    // MARK: - Tap Action
    @IBAction func TapDropDownAction(_ sender: Any)
    {
        dropDown.show()
    }
    
   
   
    @objc func scrollAutomatically(_ timer1: Timer) {
            
            if let coll  = CollPartiesToday {
                for cell in coll.visibleCells {
                    let indexPath: IndexPath? = coll.indexPath(for: cell)
                    if ((indexPath?.row)!  < 4 - 1){
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                        
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    }
                    else{
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                        coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    }
                    
                }
            }
        
//        if let coll  = CollPreviousParties {
//            for cell in coll.visibleCells {
//                let indexPath: IndexPath? = coll.indexPath(for: cell)
//                if ((indexPath?.row)!  < 4 - 1){
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
//
//                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
//                }
//                else{
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
//                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
//                }
//
//            }
//        }
        
        if let coll  = CollUpcomingPartiesHangouts {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.item)!  < 4 - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.item)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
        if let coll  = CollPartiesTrending {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < 4 - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
        if let coll  = CollPartiesNearYou {
//            for cell in coll.visibleCells {
//                let indexPath: IndexPath? = coll.indexPath(for: cell)
//                if ((indexPath?.row)!  < 4 - 1){
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
//
//                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
//                }
//                else{
//                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
//                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
//                }
//
//            }
        }
        
        if let coll  = CollPartyingNow {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < 4 - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
        if let coll  = CollPartiesToday {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < 4 - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
            
        }
    
    override func viewDidAppear(_ animated: Bool)
    {

        self.perform(#selector(self.callAllAPIsForExplore), with: nil, afterDelay: 1.0)
//        self.callAllAPIsForExplore()
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)

        
    }
    
    @objc func callAllAPIsForExplore(){
        partingNowUserDataAPI()
        upcomingPartiesAPI()
        todayPartyDataAPI()
        
    }
    
    @objc func callAllAPIsForHangout(){
        getPreviousPartiesAPI()
        upcomingPartiesHangoutAPI()
    }
    
    @objc func callAllAPIsForParties(){
        
        self.partiesNearYouAPI()
        treandingPartiesAPI()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latString = "\(locValue.latitude)"
        self.longString = "\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//
//        self.latString = "-1.4307641240010585"
//        self.longString = "36.978415150080714"

        
        self.labelTempLocation.text = "locations = \(locValue.latitude) \n \(locValue.longitude)"

        self.getAddressFromLatLon(pdblLatitude: self.latString, withLongitude: self.longString)
}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vwVisible.alpha = 0
        self.vwInvisible.alpha = 0
        
        
        setupDD()
        vw.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 25.0)
        
       
        
        self.cv.delegate = self
        self.cv.setCarouselData(paths: pathArray, describedTitle: titleArray, isAutoScroll: true, timer: 3.0, defaultImage: "defaultImage")
              //optional methods
        self.cv.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
        self.cv.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
        
//        CollPeopleCell
//        let nib = UINib(nibName: "CollPeopleCell", bundle: nil)
//        CollPeople.register(nib, forCellWithReuseIdentifier: "CollPeopleCell")
        
                lbl1.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
                       lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                       lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                       lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                       vw1.alpha = 1
                       vw2.alpha = 0
                       vw3.alpha = 0
                       vw4.alpha = 0
                       vwExplore.alpha = 1
                       vwPeople.alpha = 0
                       vwParties.alpha = 0
                       vwHangouts.alpha = 0
                
        self.refreshControlExplor.addTarget(self, action: #selector(self.refreshExploreSection), for: UIControl.Event.valueChanged)
        self.refreshControlhangouts.addTarget(self, action: #selector( self.refreshHangoutsSection), for: UIControl.Event.valueChanged)
        self.refreshControlParties.addTarget(self, action: #selector(self.refreshPartiesSection), for: UIControl.Event.valueChanged)
        
        self.scrollViewParties.refreshControl = self.refreshControlParties
        self.scrollViewHangouts.refreshControl = self.refreshControlhangouts
        self.scroollViewExplor.refreshControl = self.refreshControlExplor

        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        

        
        if switchStatus.isOn {
            self.setUserStatus(para: "online")
        }else{
            self.setUserStatus(para: "offline")
        }
        
        
        buttonEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        buttonEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        buttonGroup.backgroundColor = .white
        buttonGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)

        
        self.vwEvents.alpha = 1.0
        self.vwGroups.alpha = 0

        
        #if targetEnvironment(simulator)
        self.latString = "-1.4307641240010585"
        self.longString = "36.978415150080714"
        #else
        print("dev")
        #endif
      


//        self.latString = "23.0519099"
//        self.longString = "72.5796329"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageViewPartingNowNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
        self.imageViewPartyTodayNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
        self.imageViewPreviousPartyNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))

        self.imageViewUpcomingExploreNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
        self.imageViewHangoutUpcomingNoDtata.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))

        self.imageVIewNearYouNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
        self.imageVIewTrendingEventNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
//        self.imageViewMeetupGroupNoData.image = UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))
        
        self.imgVwMeetupGroupNoData.image =  UIImage(named: "noData")?.withRenderingMode(.alwaysTemplate).withTintColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1))

        self.imageViewPartingNowNoData.isHidden = true
        self.imageViewPartyTodayNoData.isHidden = true
        self.imageViewPreviousPartyNoData.isHidden = true
        self.imageViewUpcomingExploreNoData.isHidden = true
        self.imageViewHangoutUpcomingNoDtata.isHidden = true
        self.imageVIewNearYouNoData.isHidden = true
        self.imageVIewTrendingEventNoData.isHidden = true
//        self.imageViewMeetupGroupNoData.isHidden = false
        self.imgVwMeetupGroupNoData.isHidden = true


    }
    
    
    // MARK: - Button Action
    @IBAction func btnPartingNowViewAllAction(_ sender: Any) {
        
        lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl2.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        vw1.alpha = 0
        vw2.alpha = 1
        vw3.alpha = 0
        vw4.alpha = 0
        vwExplore.alpha = 0
        vwPeople.alpha = 1
        vwParties.alpha = 0
        vwHangouts.alpha = 0
        
        let child = self.storyboard?.instantiateViewController(withIdentifier: "PeopleVC") as! PeopleVC
        child.latString = self.latString
        child.longString = self.longString
        addChild(child)
        child.view.frame = self.vwPeople.bounds
        vwPeople.addSubview(child.view)
        child.didMove(toParent: self)
        
        
    }
    
    @IBAction func btnUpcomingPartyViewAllActioin(_ sender: Any) {
        
        lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl4.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        vw1.alpha = 0
        vw2.alpha = 0
        vw3.alpha = 0
        vw4.alpha = 1
        vwExplore.alpha = 0
        vwPeople.alpha = 0
        vwParties.alpha = 0
        vwHangouts.alpha = 1
        
        getPreviousPartiesAPI()
        upcomingPartiesAPI()
        upcomingPartiesHangoutAPI()
    }
    
    @IBAction func btnPartyTodayViewAllAction(_ sender: Any) {
        
        lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl3.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        vw1.alpha = 0
        vw2.alpha = 0
        vw3.alpha = 1
        vw4.alpha = 0
        vwExplore.alpha = 0
        vwPeople.alpha = 0
        vwParties.alpha = 1
        vwHangouts.alpha = 0
        
        
        buttonEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        buttonEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        buttonGroup.backgroundColor = .white
        buttonGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
        
        self.vwEvents.alpha = 1.0
        self.vwGroups.alpha = 0
        
        
        partiesNearYouAPI()
        treandingPartiesAPI()
                
    }
    
    @IBAction func btnMeetupViewAllAction(_ sender: Any) {
        
        
        lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lbl3.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        vw1.alpha = 0
        vw2.alpha = 0
        vw3.alpha = 1
        vw4.alpha = 0
        vwExplore.alpha = 0
        vwPeople.alpha = 0
        vwParties.alpha = 1
        vwHangouts.alpha = 0
        
        
        buttonEvent.backgroundColor = .white
        buttonEvent.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
        
        buttonGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
        buttonGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

        self.vwEvents.alpha = 0
        self.vwGroups.alpha = 1.0

        
//        partiesNearYouAPI()
//        treandingPartiesAPI()
                
        
    }
    
    @IBAction func switchValueChangeAction(_ sender: Any) {
    }
    
    @IBAction func btnBecomeAvilableAction(_ sender: Any)
    {
        self.vwInvisible.alpha = 0
    }
    @IBAction func switchVisibleAction(_ sender: UISwitch)
    {
        if sender.isOn {
            self.vwVisible.alpha = 1
            self.vwInvisible.alpha = 0
            self.setUserStatus(para: "online")
        }else{
            self.vwVisible.alpha = 0
            self.vwInvisible.alpha = 1
            self.setUserStatus(para: "offline")
        }
    }
    
    @IBAction func btnActions(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            buttonEvent.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            buttonEvent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            buttonGroup.backgroundColor = .white
            buttonGroup.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            
            self.vwEvents.alpha = 1.0
            self.vwGroups.alpha = 0
            
            self.partiesNearYouAPI()
            treandingPartiesAPI()
            

        }
        else if sender.tag == 2
        {
            buttonEvent.backgroundColor = .white
            buttonEvent.setTitleColor(#colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1), for: .normal)
            
            buttonGroup.backgroundColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            buttonGroup.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            self.vwEvents.alpha = 0
            self.vwGroups.alpha = 1.0

        }
    }
    
    @IBAction func btnVisibleNoAction(_ sender: Any)
    {
        self.vwVisible.alpha = 0
        self.vwInvisible.alpha = 0
    }
    
    @IBAction func btnVisibleYesAction(_ sender: Any)
       {
           self.vwVisible.alpha = 0
        self.vwInvisible.alpha = 1
       }
    
    
    @IBAction func btnPartyingNowAction(_ sender: UIButton)
    {
        if sender.tag == 11
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if sender.tag == 12
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
                       self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if sender.tag == 13
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
                       self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func btnHeaderActions(_ sender: UIButton)
    {
        currentSelectedTab = sender.tag

        if sender.tag == 1
        {
            lbl1.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            vw1.alpha = 1
            vw2.alpha = 0
            vw3.alpha = 0
            vw4.alpha = 0
            vwExplore.alpha = 1
            vwPeople.alpha = 0
            vwParties.alpha = 0
            vwHangouts.alpha = 0
            
            self.callAllAPIsForExplore()
        }
        else if sender.tag == 2
        {
            lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl2.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            vw1.alpha = 0
            vw2.alpha = 1
            vw3.alpha = 0
            vw4.alpha = 0
            vwExplore.alpha = 0
            vwPeople.alpha = 1
            vwParties.alpha = 0
            vwHangouts.alpha = 0
            
            let child = self.storyboard?.instantiateViewController(withIdentifier: "PeopleVC") as! PeopleVC
            child.latString = self.latString
            child.longString = self.longString
            addChild(child)
            child.view.frame = self.vwPeople.bounds
            vwPeople.addSubview(child.view)
            child.didMove(toParent: self)
        }
        else if sender.tag == 3
        {
            lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl3.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            lbl4.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            vw1.alpha = 0
            vw2.alpha = 0
            vw3.alpha = 1
            vw4.alpha = 0
            vwExplore.alpha = 0
            vwPeople.alpha = 0
            vwParties.alpha = 1
            vwHangouts.alpha = 0
            self.callAllAPIsForParties()
        
        }
        else if sender.tag == 4
        {
            lbl1.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl2.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl3.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            lbl4.textColor = #colorLiteral(red: 0.3165587187, green: 0.7593553662, blue: 0.8278911114, alpha: 1)
            vw1.alpha = 0
            vw2.alpha = 0
            vw3.alpha = 0
            vw4.alpha = 1
            vwExplore.alpha = 0
            vwPeople.alpha = 0
            vwParties.alpha = 0
            vwHangouts.alpha = 1
            self.callAllAPIsForHangout()
        }
    }
    
    // MARK: - RefreshControl Methods
    
    @objc func refreshExploreSection(){
        todayPartyDataAPI()
        upcomingPartiesAPI()
        self.refreshControlExplor.endRefreshing()
    }
    
    @objc func refreshHangoutsSection(){
        upcomingPartiesAPI()
        getPreviousPartiesAPI()
        self.refreshControlhangouts.endRefreshing()
    }
    
    @objc func refreshPartiesSection(){
        
        treandingPartiesAPI()
        partiesNearYouAPI()
        self.refreshControlParties.endRefreshing()
    }
    
    // MARK: - Private Methode

    @objc func buttonJoinClick(sender:UIButton){
        let tempArray = (sender.accessibilityIdentifier!).components(separatedBy: "-")
        
        var data:NSDictionary?
        if tempArray[0] == "PreviousPartiesHomeCell" {
            data = self.PreviousPartyData[Int(tempArray[1])!]
        }else if tempArray[0] == "PartiesNearMeHomeCell" {
            data = self.partyNearYouData[Int(tempArray[1])!]
        }else if tempArray[0] == "UpcomingPartiesHomeCell" {
            data = self.UpcomingPartyDataExplore[Int(tempArray[1])!]
        }else if tempArray[0] == "PartyTodayyCollectionViewCell" {
            data = self.todayPartyData[Int(tempArray[1])!]
        }else if tempArray[0] == "TrendingPartiesCollectionViewCell" {
            data = self.trendingPartyData[Int(tempArray[1])!]
        }else if tempArray[0] == "UpcomingPartiesHangoutCell" {
            data = self.upcomingPartyDataHangouts[Int(tempArray[1])!]
        }
        
        
        if  let isJoint = data!["is_join_event"] as? String {
           if isJoint == "no"{
            self.joinPartywith(id: data!["id"] as! Int)

           }else{
            if let tabBarController = UIApplication.shared.delegate?.window!!.rootViewController as? UITabBarController {
                   tabBarController.selectedIndex = 1
                AppDelegate.isChatcomingFrom = "events"
               }
           }
       }
        
        
    }
    
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                        self.lblDropDown.text = pm.locality! +  ", " + pm.country!
                    }
            })

        }

    
    // MARK: - API Calling
    
    func joinPartywith(id:Int)
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
        let parameters: [String: Any] = [
            "event_id" : id,
            ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "joinEvent"
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
                          DispatchQueue.main.async
                                        {
                                            APESuperHUD.dismissAll(animated: true)
                                    }
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let error = t["error"] as! String
                    print(error)
                    
                    if error == "false"
                    {
                        DispatchQueue.main.async
                        { [self] in
                            
                            if currentSelectedTab == 1{
                                self.callAllAPIsForExplore()
                            }else if  currentSelectedTab == 3{
                                self.callAllAPIsForParties()
                            }else if currentSelectedTab ==  4 {
                                self.callAllAPIsForHangout()
                            }
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                                
                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    func setUserStatus(para:String)
    {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
       
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "Bearer " + "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
        let parameters: [String: Any] = [

            "status": para
        ]
        
        print("Delete Photo Parameters->",parameters)
        
        let url =  API.BASEURL + "userOnlineStatus"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    let error_message = t["error_message"] as! String
                    
                    
                    DispatchQueue.main.async
                                  {
                                      APESuperHUD.dismissAll(animated: true)
                              }
      
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            self.view.makeToast(error_message)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            self.view.makeToast(error_message)
                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    
    func getPreviousPartiesAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "pastEventList"
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
                 
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
                            
                            DispatchQueue.main.async
                            {
                                APESuperHUD.dismissAll(animated: true)
                            }
              
//
                           if let groups = t["groups"] as?  NSArray
                           {
                            
                            if groups.count == 0 {
                                self.imageViewPreviousPartyNoData.isHidden = false
                                return
                            }else{
                                self.imageViewPreviousPartyNoData.isHidden = true
                                self.PreviousPartyData.removeAll()

                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.PreviousPartyData.append(t)
                                }
                                self.CollPreviousParties.reloadData()
                                self.constraintPreviousHeight.constant = CGFloat(210 * self.PreviousPartyData.count)
                                self.constraintViewHangoutContainrHeight.constant = 360 + self.constraintPreviousHeight.constant
                               }
                            }
                            
                           
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            DispatchQueue.main.async
                            {
                                APESuperHUD.dismissAll(animated: true)
                            }
                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    func upcomingPartiesAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "upcomingEventList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
           
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                          
                            APESuperHUD.dismissAll(animated: true)

//
                            let groups = t["groups"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageViewUpcomingExploreNoData.isHidden = false
                                return
                            }else{
                                self.UpcomingPartyDataExplore.removeAll()

                                self.imageViewUpcomingExploreNoData.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.UpcomingPartyDataExplore.append(t)
                                }
                                self.CollExplore.reloadData()
                            }
                            
                         
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    func upcomingPartiesHangoutAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "upcomingEventList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
                          
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
                            APESuperHUD.dismissAll(animated: true)

//
                            let groups = t["groups"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageViewHangoutUpcomingNoDtata.isHidden = false
                                return
                            }else{
                                
                                self.upcomingPartyDataHangouts.removeAll()

                              self.imageViewHangoutUpcomingNoDtata.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.upcomingPartyDataHangouts.append(t)
                                }
                                self.CollUpcomingPartiesHangouts.reloadData()
                            }
                            
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    func todayPartyDataAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: Date())
//
        let parameters: [String: String] = [
            "todaydate": dateStr,
            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "todayEventList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            APESuperHUD.dismissAll(animated: true)

//
                            let groups = t["groups"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageViewPartyTodayNoData.isHidden = false
                                return
                            }    else{
                                
                                self.todayPartyData.removeAll()

                                self.imageViewPartyTodayNoData.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.todayPartyData.append(t)
                                }
                                self.CollPartiesToday.reloadData()
                                
                            }
                            
                        
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    
    func partiesNearYouAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "currentEventList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
                                            APESuperHUD.dismissAll(animated: true)

                            let groups = t["groups"] as! NSArray
                            
                            if groups.count == 0 {
                                self.imageVIewNearYouNoData.isHidden = false
                                return
                            }  else{
                                
                                self.partyNearYouData.removeAll()

                                self.imageVIewNearYouNoData.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.partyNearYouData.append(t)
                                }
                                self.CollPartiesNearYou.reloadData()
                                self.constraintHeightPartyNearYou.constant = CGFloat(210 * self.partyNearYouData.count)
                                self.constraintHeightContainerView.constant = 360 + self.constraintHeightPartyNearYou.constant
                            }
                            
                           
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }

    func treandingPartiesAPI()
    {
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "trendingEventList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                          
            
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            APESuperHUD.dismissAll(animated: true)

//
                            let groups = t["groups"] as! NSArray
                            
                            
                            if groups.count == 0 {
                                self.imageVIewTrendingEventNoData.isHidden = false
                                return
                            }else{
                                
                                self.trendingPartyData.removeAll()

                                self.imageVIewTrendingEventNoData.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.trendingPartyData.append(t)
                                }
                                self.CollPartiesTrending.reloadData()
                            }
                           
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
    
    func partingNowUserDataAPI()  {
        
         DispatchQueue.main.async
                   {
                       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
               }
        
      
        
        let tokn = UserDefaults.standard.string(forKey: "access_token")
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: SESSION.authToken) as String?
                    {
                         print(accesstoken)
                        headers = [
                            "Authorization": "Bearer " + accesstoken,
                            "Accept": "application/json"
                        ]
                    }
                    else
                    {
                        headers = [
                            "Authorization": "",
                            "Accept": "application/json"
                        ]
                    }
    
       
        
//
        let parameters: [String: String] = [

            "latitude":self.latString,
            "longitude":self.longString
        ]
        
//        print("Delete Contact Parameters->",parameters)
        
        let url =  API.BASEURL + "partyNowUsersList"
        
        
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        
            
            print(response.result)
            
//            SwiftSpinner.hide()
            
                
            
            switch response.result {
              
                
            case .success(_):
                if let json = response.value
                {
                    //                    successHandler((json as! [String:AnyObject]))
                    let t = json as! NSDictionary
                    print(t)
                    //
                    
                    let success = t["error"] as! String
                    print(success)
                    
                    if success == "false"
                    {
                        DispatchQueue.main.async
                        {
                            
                                            APESuperHUD.dismissAll(animated: true)

                            let groups = t["users"] as! NSArray
                            //
                            if groups.count == 0 {
                                self.imageViewPartingNowNoData.isHidden = false
                                return
                            }else{
                                self.partingNowUserData.removeAll()

                                self.imageViewPartingNowNoData.isHidden = true
                                for i in groups
                                {
                                    let t = i as! NSDictionary
                                    self.partingNowUserData.append(t)
                                }
                                self.CollPartyingNow.reloadData()
                            }
                          
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                            APESuperHUD.dismissAll(animated: true)

                        }
                        
                    }
                    
                    
                    
                }
                break
            case .failure(let error):
                //                failureHandler([error as Error])
                print(error)
                break
            }
        }
    }
}

// MARK: - CollectionView Delegate


extension HomeVC {
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == CollPreviousParties
        {
            return self.PreviousPartyData.count
        }
        else if collectionView == CollUpcomingPartiesHangouts
        {
            return self.upcomingPartyDataHangouts.count
        }
        else if collectionView == CollExplore
        {
            return self.UpcomingPartyDataExplore.count
        }
        else if collectionView == CollPartiesNearYou
        {
            return self.partyNearYouData.count
        }
        else if collectionView == CollPartiesToday
        {
            return self.todayPartyData.count
        }
        else if collectionView == CollPartiesTrending
        {
            return self.trendingPartyData.count
            
        }else if collectionView == CollPartyingNow {
            
            return partingNowUserData.count
        }
        else if collectionView == collMeetupGroups {
            return 2
        }else
        {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == CollPeople
        {
            let cell = CollPeople.dequeueReusableCell(withReuseIdentifier: "CollPeopleCell", for: indexPath) as! CollPeopleCell
            
//            cell.vw.roundCorners(corners: [.bottomRight,.bottomLeft], radius: 15.0)
            
            return cell
        }
        else if collectionView == CollUpcomingPartiesHangouts
        {
            let cell = CollUpcomingPartiesHangouts.dequeueReusableCell(withReuseIdentifier: "UpcomingPartiesHangoutCell", for: indexPath) as! UpcomingPartiesHangoutCell
            print(self.UpcomingPartyDataExplore)
            let tdata = self.upcomingPartyDataHangouts[indexPath.item] as! NSDictionary
            
            if  let isJoint = tdata["is_join_event"] as? String {
               if isJoint == "no"{
                   cell.labelJoin.text = "Join"
               }else{
                   cell.labelJoin.text = "Message"
               }
           }
            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }
            
            cell.buttonJoin.accessibilityIdentifier =  "CollUpcomingPartiesHangouts-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)
            
            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }
            
            
            
//            cell.lblPartyEndMonth.text = first3
            
            
            return cell
        }
        else if collectionView == CollPreviousParties
        {
            let cell = CollPreviousParties.dequeueReusableCell(withReuseIdentifier: "PreviousPartiesHomeCell", for: indexPath) as! PreviousPartiesHomeCell
            
            let tdata = self.PreviousPartyData[indexPath.item ] as! NSDictionary
            
            if  let isJoint = tdata["is_join_event"] as? String {
               if isJoint == "no"{
                   cell.labelJoin.text = "Join"
               }else{
                   cell.labelJoin.text = "Message"
               }
           }
            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }
            
            
            cell.buttonJoin.accessibilityIdentifier =  "PreviousPartiesHomeCell-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)

            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }

            
            return cell
        }
        else if collectionView == CollPartiesNearYou
        {
            let cell = CollPartiesNearYou.dequeueReusableCell(withReuseIdentifier: "PartiesNearMeHomeCell", for: indexPath) as! PartiesNearMeHomeCell
            let tdata = self.partyNearYouData[indexPath.item ] as! NSDictionary

            if  let isJoint = tdata["is_join_event"] as? String {
               if isJoint == "no"{
                   cell.labelJoin.text = "Join"
               }else{
                   cell.labelJoin.text = "Message"
               }
           }

            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }
            
            
            cell.buttonJoin.accessibilityIdentifier =  "PartiesNearMeHomeCell-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)

            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
 
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }
            
            return cell
        }
        else if collectionView == CollPartyingNow
        {
            let cell = CollPartyingNow.dequeueReusableCell(withReuseIdentifier: "PartiesNowHomeCwll", for: indexPath) as! PartiesNowHomeCwll
            let data = self.partingNowUserData[indexPath.item]
            if let imaeg = data["image"] as? String{
                if !imaeg.isEmpty{
                    let url = URL(string: imaeg)
                    if url != nil {
                        cell.imageViewUserProfile.kf.setImage(with: url)
                    }else{
                        cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
                    }
                }else{
                    cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
                }
            }else{
                cell.imageViewUserProfile.image = UIImage(named: "defaultUser")
            }
            cell.labelName.text = (data["first_name"] as! String)
            
            if let isOnline = (data["isOnline"] as? String) {
                if isOnline == "online" {
                    cell.viewOnlineStatus.backgroundColor = .systemGreen
                }else{
                    cell.viewOnlineStatus.backgroundColor = .systemGray
                }
            }
            
            if let gender = (data["gender"] as? String) {
                if gender == "male"{
                    cell.labelGender.text = "M"
                }else{
                    cell.labelGender.text = "F"
                }
            }
            
            let distance = data["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            cell.labelStatus.text = doubleStr + " KM"
            
            if let age = (data["age"] as? Int) {
                cell.labelAge.text = "\(age)"
            }
            return cell
        }
        else if collectionView == CollPartiesToday
        {
            let cell = CollPartiesToday.dequeueReusableCell(withReuseIdentifier: "PartyTodayyCollectionViewCell", for: indexPath) as! PartyTodayyCollectionViewCell
            
            print("================ \( self.todayPartyData.count)")

            let tdata = self.todayPartyData[indexPath.item] as! NSDictionary

             if  let isJoint = tdata["is_join_event"] as? String {
                if isJoint == "no"{
                    cell.labelJoin.text = "Join"
                }else{
                    cell.labelJoin.text = "Message"
                }
            }
            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }

            
            cell.buttonJoin.accessibilityIdentifier =  "PartyTodayyCollectionViewCell-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)
            
            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
    
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }
            
            
                return cell
        }else if collectionView == CollPartiesTrending {
            
            let cell = CollPartiesTrending.dequeueReusableCell(withReuseIdentifier: "TrendingPartiesCollectionViewCell", for: indexPath) as! TrendingPartiesCollectionViewCell
            
            print("================ \( self.trendingPartyData.count)")
            let tdata = self.trendingPartyData[indexPath.item] as! NSDictionary

            if  let isJoint = tdata["is_join_event"] as? String {
               if isJoint == "no"{
                   cell.labelJoin.text = "Join"
               }else{
                   cell.labelJoin.text = "Message"
               }
           }
            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }

            
            
            cell.buttonJoin.accessibilityIdentifier =  "TrendingPartiesCollectionViewCell-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)
            
            
            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
            
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }
            
            
            return cell
        }
        else if collectionView == collMeetupGroups {
            let cell = collMeetupGroups.dequeueReusableCell(withReuseIdentifier: "MeetupGroupCollectioCell", for: indexPath) as! MeetupGroupCollectioCell
            if indexPath.item == 0 {
            cell.labelStaus.text = "Going out for drink"
            }else{
                cell.labelStaus.text = "hanging out."
            }
            return cell
        }else
        {
            let cell = CollExplore.dequeueReusableCell(withReuseIdentifier: "UpcomingPartiesHomeCell", for: indexPath) as! UpcomingPartiesHomeCell
           
            let tdata = self.UpcomingPartyDataExplore[indexPath.item] as! NSDictionary
            
            if  let isJoint = tdata["is_join_event"] as? String {
               if isJoint == "no"{
                   cell.labelJoin.text = "Join"
               }else{
                   cell.labelJoin.text = "Message"
               }
           }
            
            if let userList = tdata["join_event_user_list"] as? [NSDictionary]{
                cell.labelUserCoount.text = "+\(userList.count)"
            }
            
            
            cell.buttonJoin.accessibilityIdentifier =  "UpcomingPartiesHomeCell-" + "\(indexPath.item)"
            cell.buttonJoin.addTarget(self, action: #selector(self.buttonJoinClick(sender:)), for: .touchUpInside)
            
            
            let event_image = tdata["event_image"] as! String
            let url = URL(string: event_image)
            cell.img.kf.setImage(with: url)
            
            let event_name = tdata["event_name"] as! String
            cell.lblPartyName.text = event_name
            
            let vanue_name = tdata["vanue_name"] as! String
            let distance = tdata["distance"] as! NSNumber
            let tt = distance as! Double
            let doubleStr = String(format: "%.2f", tt)
            print(doubleStr)
            cell.lblVenueName.text = vanue_name + " (" + doubleStr + "KM Away)"
            
            let event_start_time = tdata["event_start_time"] as! String
            cell.lblPartyEndTime.text = event_start_time
            
            let event_start_date = tdata["event_start_date"] as! String
            let event_last_date = tdata["event_end_date"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: event_start_date)
            print("Date->",date)
            
            let dateEnd  = dateFormatter.date(from: event_last_date)
            print("Date->",dateEnd)

            
            dateFormatter.dateFormat = "MMM-dd"
            let fdate = dateFormatter.string(from: date!)
            let endDate = dateFormatter.string(from: dateEnd!)

//            print(dateFormatter.string(from: date!))
            print("change formate date->",fdate)
            let first3 = String(fdate.prefix(3))
            let first3end = String(endDate.prefix(3))
            
            let last2 = fdate.suffix(2)
            let last2end = endDate.suffix(2)
            
            if first3 == first3end {
                cell.lblPartyEndMonth.text = first3
                cell.lblPartyEndDate.text = String(last2) + "-" + String(last2end)
            }else{
                cell.lblPartyEndDate.text = String(last2) + "-" + first3
                cell.lblPartyEndMonth.text =  String(last2end) + "-" + first3end
            }
            
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        if collectionView == CollPeople
        {
            return CGSize(width: collectionViewSize, height: 550)
        }
        else if collectionView == CollPartyingNow
        {
            let padding1: CGFloat =  10
            let collectionViewSize1 = collectionView.frame.size.width - padding1
            
            return CGSize(width: collectionViewSize1/3, height: 170)
        }
        else
        {
            return CGSize(width: collectionViewSize, height: 200)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == CollPartyingNow
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
            let data = self.partingNowUserData[indexPath.item]
            vc?.latString = self.latString
            vc?.longString = self.longString
            vc?.userID = (data["id"] as! Int)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else  if collectionView == CollPeople
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if collectionView == collMeetupGroups {
            
        }
        else
        {
            var eventId:Int?
            if collectionView == CollExplore {
                let data = UpcomingPartyDataExplore[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)
            }else if collectionView == CollPartiesToday{
                let data = todayPartyData[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)
            }else if collectionView == CollPartiesNearYou {
                let data = partyNearYouData[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)
            }else if collectionView == CollPreviousParties{
                let data = PreviousPartyData[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)
            }else if collectionView == CollPartiesTrending {
                let data = trendingPartyData[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)
            }else if collectionView == CollUpcomingPartiesHangouts {
                let data = upcomingPartyDataHangouts[indexPath.item] as! [String:Any]
                eventId = (data["id"] as! Int)

            }
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartyDetailsVC") as? PartyDetailsVC
            vc?.eventId = eventId
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        

    }
}
