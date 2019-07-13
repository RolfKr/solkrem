//
//  AddLocation.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 13/07/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationNameDelegate {
    func didEnterPlaceName(latitiude: String, longitude: String, region: String)
}

class AddLocationVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var searhBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 10000
    var previousLocation: CLLocation?
    var locationNameDelegate: LocationNameDelegate?    
    var location: LocationString?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = false
        checkLocationAuthorization()
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        print("Hello1")
        guard let location = location else {return}
        print("Hello2")
        locationNameDelegate?.didEnterPlaceName(latitiude: location.latitude, longitude: location.longitude, region: location.city)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centerLocationTapped(_ sender: UIButton) {
        centerViewOnUserLocation()
    }
    
    @IBAction func searhBtnPressed(_ sender: UIButton) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                self.searchAlert()
            } else {
                guard let latitude = response?.boundingRegion.center.latitude else {return}
                guard let longitude = response?.boundingRegion.center.longitude else {return}
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: self.regionInMeter, longitudinalMeters: self.regionInMeter)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func searchAlert() {
        let alert = UIAlertController(title: "Ikke funnet", message: "Vi finner ikke det du søker etter.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Prøv Igjen", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationServices()
        } else {
            // Show alert letting the user know they have to turn location services on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            previousLocation = getCenterLocation(for: mapView)
        case .denied:
            //Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show an alert about restricted.
            break
        case .authorizedAlways:
            break
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension AddLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
}

extension AddLocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        

        
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 50 else {return}
        
        enterBtn.isHidden = false
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let _ = self else {return}
            
            if let _ = error {
                //show alert
                return
            }
            
            guard let placemark = placemarks?.first else {return}
            
            guard let city = placemark.locality else {return}
            let latitudeText = String(format: "%f", (placemark.location?.coordinate.latitude)!)
            let longitudeText = String(format: "%f", (placemark.location?.coordinate.longitude)!)

            self?.location = LocationString(latitude: latitudeText, longitude: longitudeText, city: city)

            print(self?.location?.latitude)
            print(self?.location?.longitude)
            print(city)
            
            
        }
    }
}
