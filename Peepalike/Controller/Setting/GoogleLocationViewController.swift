//
//  GoogleLocationViewController.swift
//  Peepalike
//
//  Created by Rao, Bhavesh (external - Project) on 03/04/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import GooglePlaces

protocol UserSelectedLocationDelegate {
    func userSelectedLocation(address:String,lat:Double,long:Double)
}
class GoogleLocationViewController: UIViewController {

    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var delegate:UserSelectedLocationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Addres"
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        definesPresentationContext = true

    }
    
    @IBAction func cancelAct(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
      }
}
    
extension GoogleLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            searchController?.isActive = false
            // Do something with the selected place.
            print("Place Address: \(place.formattedAddress ?? "")")
            searchController?.searchBar.text = place.formattedAddress
            delegate?.userSelectedLocation(address: place.formattedAddress!, lat: place.coordinate.latitude, long: place.coordinate.longitude)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error){
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

