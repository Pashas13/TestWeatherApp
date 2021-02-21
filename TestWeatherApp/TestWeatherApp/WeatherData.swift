//
//  WeatherData.swift
//  TestWeatherApp
//
//  Created by Pasha on 17.02.2021.
//

import Foundation

class WeatherData: Codable {
    let data: [DayWeather]
    let timeZone: String
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case timeZone = "timezone"
        case cityName = "city_name"
    }
}

class DayWeather: Codable {
    let weather: Weather
    let date: String
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    let sunrise: Int
    let sunset: Int
    let windDirection: String
    let snow: Double
    let humidity: Int
    let windSpeed: Double
    let windCdir: String
    let feelsLike: Double
    let precipitation: Double
    let pressure: Double
    let visibility: Int
    let uvIndex: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "datetime"
        case weather
        case temp
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case sunrise = "sunrise_ts"
        case sunset = "sunset_ts"
        case windDirection = "wind_cdir_full"
        case snow
        case humidity = "rh"
        case windSpeed = "wind_spd"
        case windCdir = "wind_cdir"
        case feelsLike = "dewpt"
        case precipitation = "vis"
        case pressure = "pres"
        case visibility = "pop"
        case uvIndex = "uv"
    }
}

class Weather: Codable {
    let icon: String
    let description: String
}
