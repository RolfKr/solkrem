//
//  AddPlaceVC.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 25/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreLocation

protocol PlaceNameDelegate {
    func didEnterPlaceName(latitiude: String, longitude: String, region: String)
    func didEnterLocatioName(location: CLLocation, region: String)
}

class AddPlaceVC: UIViewController {

    @IBOutlet weak var placeName: UITextField!
    
    var placeNameDelegate: PlaceNameDelegate?
    var adressValid = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeRight()
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        convertToCoords()
    }
    
    func presentAlert(){
        let alert = UIAlertController(title: "Feil", message: "Oppgitt lokasjon finnes ikke", preferredStyle: .alert)
        let action = UIAlertAction(title: "Lukk", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func convertToCoords() {
        
        guard let place = placeName.text else {return}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(place) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {return self.adressValid = false}
            
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            self.adressValid = true
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            self.placeNameDelegate?.didEnterPlaceName(latitiude: latitude, longitude: longitude, region: place)
            self.placeNameDelegate?.didEnterLocatioName(location: location, region: place)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismissView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func addSwipeRight() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    
}
