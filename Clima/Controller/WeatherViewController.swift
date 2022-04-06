//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    
    

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
  
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        cityTextField.delegate = self
        
        updateUI()
    }
    
    @IBAction func getUserLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func updateUI(){
        
    }
}

//MARK: -UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchCityPressed(_ sender: UIButton) {
        print(cityTextField.text!)
        cityTextField.endEditing(true)
       
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if cityTextField.text != "" {
            cityTextField.placeholder = "Search"
            return true
        } else {
            cityTextField.placeholder = "Type Something..."
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = cityTextField.text?.trimmingCharacters(in: .whitespaces) {
            weatherManager.fetchWeather(cityName: city)
            
        }
        
        
        
        cityTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(cityTextField.text!)
        cityTextField.endEditing(true)
        return true
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    func didFailError(_ error: Error) {
        print(error)
    }
}

//MARK: - Location Manager

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat, lon)
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

