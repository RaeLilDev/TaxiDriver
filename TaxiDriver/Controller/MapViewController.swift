//
//  MapViewController.swift
//  TaxiDriver
//
//  Created by Ye Lynn Htet on 31/12/2021.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    var selectedCustomer: CustomerModel?
    var currentLat: Double?
    var currentLog: Double?
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var separatorView: UIView!
    var zoom:Float = 12
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let customer = selectedCustomer, let fromLat = currentLat, let fromLog = currentLog {
            createMapView(with: customer, sourceLat: fromLat, sourceLog: fromLog)
            distanceLabel.text = "Distance: \(customer.cusDistance)km"
        }
        
        separatorView.layer.cornerRadius = 2
        
        mapView.layer.cornerRadius = 16
        mapView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        
    }
    
    func createMapView(with customer: CustomerModel, sourceLat: Double, sourceLog: Double) {
            
        let camera = GMSCameraPosition.camera(withLatitude: sourceLat, longitude: sourceLog, zoom: zoom)
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLog)
        sourceMarker.title = "Driver"
        sourceMarker.snippet = userDefaults.string(forKey: "username")
        sourceMarker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.2870260477, green: 0.4614092708, blue: 1, alpha: 1))
        sourceMarker.map = mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: customer.cusLat, longitude: customer.cusLog)
        destinationMarker.title = "Customer"
        destinationMarker.snippet = customer.cusName
        destinationMarker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))
        destinationMarker.map = mapView
    }
    
    
    @IBAction func zoomInPressed(_ sender: UIButton) {
        zoom += 1
        mapView.animate(toZoom: zoom)
    }
    
    
    @IBAction func zoomOutPressed(_ sender: Any) {
        zoom -= 1
        mapView.animate(toZoom: zoom)
    }
    
    @IBAction func myLocationPressed(_ sender: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: currentLat!, longitude: currentLog!, zoom: zoom)
        
        mapView.camera = camera
    }
}
