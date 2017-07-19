//
//  LibraryDetailsViewController.swift
//  Libraries
//
//  Created by Stephen Moon on 2017-07-12.
//  Copyright © 2017 stephendmoon. All rights reserved.
//

import UIKit
import MapKit

class LibraryDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    var libraryInfo: Dictionary<String, Any> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // show title and labels
        self.navigationItem.title = "Information"
        nameLabel.text = libraryInfo["name_"] as? String
        addressLabel.text = libraryInfo["address"] as? String
        hoursLabel.text = libraryInfo["hours_of_operation"] as? String
        
        // show map
        let annotation = MKPointAnnotation.init()
        let location = libraryInfo["location"] as! Dictionary<String, Any>
        let latitude = Double(location["latitude"] as! String)
        let longitude = Double(location["longitude"] as! String)
        let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        annotation.coordinate = coordinate
        annotation.title = libraryInfo["name_"] as? String
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.005
        span.longitudeDelta = 0.005
        region.span = span
        region.center = coordinate
        mapView.region = region
        mapView.regionThatFits(region)
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
