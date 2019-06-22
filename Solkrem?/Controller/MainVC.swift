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
    
    
    
    // ACKNOWLEDMENTS
    // https://www.flaticon.com/free-icon/sunscreen_1861721#term=sunscreen&page=1&position=17
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var UVLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var needSunscreenLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    let condition = WeatherCondition()
    var location: Location?
    var temp: String?
    var uv: String?
    var weatherData: WeatherData?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        checkLocationServices()
    }
    
    
    func getWeather() {
        
        guard let locationLat = location?.latitude else {return}
        guard let locationLon = location?.longitude else {return}
        let latString = String(locationLat)
        let lonString = String(locationLon)

        networking.getUVStatus(appID: "52a3d9ce895b620fc9ae5ccc0b53d71f", latitude: latString, longitude: lonString) { (weatherUV) in
            guard let uv = weatherUV.value else {return}
            
            let formatted = String(uv)
            self.uv = "UV: \(formatted)"
            
            DispatchQueue.main.async {
                self.configureUI()
                self.getSunscreenInfo(uvNum: uv)
            }
        }
        
        networking.getWeatherStatus(appID: "52a3d9ce895b620fc9ae5ccc0b53d71f", latitude: latString, longitude: lonString) { (weatherForecast) in
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
        
        let condition = WeatherCondition()

        print(uvNum)
        
        switch condition.getUVStatus(condition: uvNum) {
        case "Lav":
            return needSunscreenLabel.text = "Nivå: Lav"
        case "Moderat":
            return needSunscreenLabel.text = "Nivå: Moderat"
        case "Høy":
            return needSunscreenLabel.text = "Nivå: Høy"
        case "Svært Høy":
            return needSunscreenLabel.text = "Nivå: Svært Høy"
        case "Ekstrem":
            return needSunscreenLabel.text = "Nivå: Ekstrem"
        default:
            return needSunscreenLabel.text = "Nivå: Ukjent"
        }
        /*
        if uvNum < 3.0 {
            needSunscreenLabel.text = "NEI"
        } else {
            needSunscreenLabel.text = "JA!"
        }
         */
    }
    
    func getWeatherIcon(id: Int) {
        let weatherIcon = condition.getWeatherCondition(id: id)
        imageView.image = UIImage(named: weatherIcon)
    }
    
    @IBAction func reloadLocation(_ sender: UIButton) {
        checkLocationServices()
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
            getWeather()
        }
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
