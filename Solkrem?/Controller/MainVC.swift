//
//  ViewController.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var UVLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var needSunscreenLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var positionBtn: UIButton!
    
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    let condition = WeatherCondition()
    var location: Location?
    var temp: String?
    var uv: String?
    var weatherData: WeatherData?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.minimumScaleFactor = 0.1
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.lineBreakMode = .byClipping
        tempLabel.numberOfLines = 0
        
        UVLabel.minimumScaleFactor = 0.1
        UVLabel.adjustsFontSizeToFitWidth = true
        UVLabel.lineBreakMode = .byClipping
        UVLabel.numberOfLines = 0
        
        checkLocationServices()
        
        positionBtn.imageView?.contentMode = .scaleAspectFit

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        checkLocationServices()
    }
    
    
    func getWeather(latitude: String, longitude: String) {


        networking.getUVStatus(appID: "52a3d9ce895b620fc9ae5ccc0b53d71f", latitude: latitude, longitude: longitude) { (weatherUV) in
            guard let uv = weatherUV.value else {return}
            
            let formatted = String(uv)
            self.uv = "UV: \(formatted)"
            
            DispatchQueue.main.async {
                self.configureUI()
                self.getSunscreenInfo(uvNum: uv)
            }
        }
        
        networking.getWeatherStatus(appID: "52a3d9ce895b620fc9ae5ccc0b53d71f", latitude: latitude, longitude: longitude) { (weatherForecast) in
            guard let myTemp = weatherForecast.main.temp else {return}
            guard let weatherID = weatherForecast.weather?.first?.id else {return}
            
            
            let fromKelvin = myTemp - 273.15
            let formatted = String(format: "%.0f", fromKelvin)
            
            self.temp = "\(formatted)℃"
            
            DispatchQueue.main.async {
                self.configureUI()
                self.getWeatherIcon(id: weatherID)
            }
            
            
        }

    }
    
    func configureUI() {
        tempLabel.text = temp
        UVLabel.text = uv
    }
    
    func locationServicesNotEnabled(){
        let alert = UIAlertController(title: "Mangler lokasjon", message: "Vi har ikke tilgang til å finne din lokasjon. Vennligst aktiver dette under innstillinger på din iPhone", preferredStyle: .alert)
        let action = UIAlertAction(title: "Lukk", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func errorGettingLocation(){
        let alert = UIAlertController(title: "Mangler GPS signal", message: "Vi mottar ikke noe GPS signal. Forsøk å gå til en annen lokasjon, eller prøv igjen senere.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Lukk", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func getSunscreenInfo(uvNum: Double) {

        let sunScreenInfo = condition.getSunTips(status: condition.getUVStatus(condition: uvNum))
        weatherDescLabel.text = sunScreenInfo
                
        switch condition.getUVStatus(condition: uvNum) {
        case "Lav":
            return needSunscreenLabel.text = "Lav"
        case "Moderat":
            return needSunscreenLabel.text = "Moderat"
        case "Høy":
            return needSunscreenLabel.text = "Høy"
        case "Svært Høy":
            return needSunscreenLabel.text = "Svært Høy"
        case "Ekstrem":
            return needSunscreenLabel.text = "Ekstrem"
        default:
            return needSunscreenLabel.text = "Ukjent"
        }
    }

    
    
    func getWeatherIcon(id: Int) {
        let weatherIcon = condition.getWeatherCondition(id: id)
        imageView.image = UIImage(named: weatherIcon)
    }
    
    @IBAction func reloadTapped(_ sender: UIButton) {
        
        checkLocationServices()
        
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlaceSegue" {
            if let addPlaceVC = segue.destination as? AddPlaceVC {
                addPlaceVC.placeNameDelegate = self
            }
        }
    }
    
    
}

extension MainVC : CLLocationManagerDelegate {
    
    // HANDLES ALL LOCATION SERVICES
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            locationServicesNotEnabled()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLocation = locations.first {
            location = Location(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            
            guard let location = location else {return}
            guard let loc = locations.first else {return}
            
            getPlacemark(forLocation: loc) { (placemark, string) in
                guard let placeCity = placemark?.locality else {return}
                let city = String(placeCity)
                
                DispatchQueue.main.async {
                    self.updateCityLabel(city: city)
                }
            }
            
            let latitude = String(location.latitude!)
            let longitude = String(location.longitude!)
            
            getWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func updateCityLabel(city: String) {
        adressLabel.text = "\(city)"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorGettingLocation()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //Show alert letting them now parental control might be on
            break
        default:
            break
        }
    }
    
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Unable to find placemark")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
        
    }
}

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func toInt() -> Int? {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return nil
        }
        
        return Int(self)
    }
}

extension MainVC: PlaceNameDelegate {
    
    func didEnterPlaceName(latitiude: String, longitude: String, region: String) {
        getWeather(latitude: latitiude, longitude: longitude)
    }
    
    func didEnterLocatioName(location: CLLocation, region: String) {
        
        getPlacemark(forLocation: location) { (placemark, string) in
            guard let placemark = placemark else {return}
            guard let city = placemark.locality else {return}
            DispatchQueue.main.async {
                self.updateCityLabel(city: city)
            }
        }
    }
}
