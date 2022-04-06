//
//  WeatherManager.swift
//  Clima
//
//  Created by Marco Mascorro on 4/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailError(_ error: Error)
}

struct WeatherManager {

    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=31b928bbacb19b6fa37259041d320a32&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String ) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let url = "\(url)&q=\(city)"
        performRequest(urlstring: url)
    }
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let url = "\(url)&lat=\(lat)&lon=\(lon)"
        print(url)
        performRequest(urlstring: url)
    }
    func performRequest(urlstring: String){
        if let url = URL(string: urlstring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data,  respose, error in
                if error != nil {
                    self.delegate?.didFailError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName, weather.temperatureString)
            return weather
            
            
            
          
        } catch {
            delegate?.didFailError(error)
            
            return nil
        }
    }
    
    func getConditionName(weatherId: Int) -> String{
        return ""
    }
}
