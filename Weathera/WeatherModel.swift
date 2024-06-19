//
//  WeatherModel.swift
//  Weathera
//
//  Created by Tomas Sanni on 6/19/24.
//

import Foundation


struct WeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    
    
    var temperatureString: String {
        return String(format: "%.1f", main.temp)
    }
    
    var conditionName: String {
        switch weather[0].id {
        case 200...232:
            return "cloud.bolt.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }
    
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
