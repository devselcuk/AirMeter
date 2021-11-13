//
//  MeterMapViewController.swift
//  AirMeter
//
//  Created by MacMini on 19.10.2021.
//

import UIKit
import MapKit

var globalLocation : CLLocation?

class MeterMapViewController: UIViewController {
    @IBOutlet weak var fingoView: UIView!
    
    
    let mapView = MKMapView()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = fingoView.bounds
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        fingoView.addSubview(mapView)
        
        fingoView.clipsToBounds = true
        fingoView.layer.cornerRadius = 16
        
        mapView.mapType = .hybrid
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapSelector(_:))))

        // Do any additional setup after loading the view.
    }
    
    
   @objc func mapSelector(_ tap : UITapGestureRecognizer) {
        
        let lokasyon = tap.location(in: mapView)
        
        let koodinat = mapView.convert(lokasyon, toCoordinateFrom: mapView)
        
        let mapLokasyon = CLLocation(latitude: koodinat.latitude, longitude: koodinat.longitude)
        
        globalLocation = mapLokasyon
       print(globalLocation)
        self.tabBarController?.selectedIndex = 0
        
    }
    


}
