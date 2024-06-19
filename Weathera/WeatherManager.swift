//
//  WeatherManager.swift
//  Weathera
//
//  Created by Tomas Sanni on 6/19/24.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid="
    
    var apiKey: String? {
        get {
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
               let xml = FileManager.default.contents(atPath: path),
               let keyDict = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any],
               let apiKey = keyDict["apikey"] as? String {
                return apiKey
            } else {
                fatalError("API Key not found in Keys.plist")
            }
        }
    }
    
    
//    let apiKey = Bundle.main.object(forInfoDictionaryKey: "apikey") as? String
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        guard let apiKey = apiKey else { return }
        let urlString = "\(weatherURL)\(apiKey)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let apiKey = apiKey else { return }
        let urlString = "\(weatherURL)\(apiKey)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
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
            let decodedData = try decoder.decode(WeatherModel.self, from: weatherData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    } 
}
