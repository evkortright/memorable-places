//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Enrique V. Kortright on 5/12/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var place : Place? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        print("MapViewController.viewDidLoad place: \(String(describing: place))")
        if place != nil {
            showPlace()
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(uiGestureRecognizer:)))
            uilpgr.minimumPressDuration = 2
            
            mapView.addGestureRecognizer(uilpgr)
        }
    }
    
    func longpress(uiGestureRecognizer: UIGestureRecognizer) {
        print("longpress")
        if (uiGestureRecognizer.state == .began) {
            let touchPoint = uiGestureRecognizer.location(in: self.mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            reverseLookupAndSavePlace(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func showPlace() {
        let latitude : CLLocationDegrees = place!.latitude
        let longitude : CLLocationDegrees = place!.longitude
        let latDelta : CLLocationDegrees = 0.005
        let lonDelta : CLLocationDegrees = 0.005
        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation : MKPointAnnotation = MKPointAnnotation()
        annotation.title = place?.name
        annotation.subtitle = String(format: "%.4f", place!.latitude) + "," +
            String(format: "%.4f", place!.longitude)
        annotation.coordinate = center
        mapView.addAnnotation(annotation)

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latDelta : CLLocationDegrees = 0.005
        let lonDelta : CLLocationDegrees = 0.005
        let center : CLLocationCoordinate2D = locations[0].coordinate
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func reverseLookupAndSavePlace(latitude : Double, longitude : Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Error reverse geocoding: \(String(describing: error))")
            } else {
                if let placemark = placemarks?[0] {
                    let formattedAddressLines = placemark.addressDictionary?["FormattedAddressLines"] as! [String]
                    var address = ""
                    for line in formattedAddressLines {
                        print("line: \(line)")
                        address += line + "\n"
                    }
                    if address.characters.count > 0 {
                        print("address: \(String(describing: address))")
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = placemark.location!.coordinate
                        annotation.title = address
                        // annotation.subtitle = "Good place!"
                        self.mapView.addAnnotation(annotation)
                        createPlace(name: address, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    }
                }
            }
        }
    }
}
