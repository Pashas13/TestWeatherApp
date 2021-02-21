//
//  ForecastModel.swift
//  TestWeatherApp
//
//  Created by Pasha on 20.02.2021.
//

import Foundation

struct ForecastModel: Codable {
    let hourlyWeather: [HourlyWeather]
    let city: String
    let descr: String
    let currentTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let dailyWeather: [DailyWeather]
    let fullDescription: String
    let sunrise: String
    let sunset: String
    let snow: Int
    let humidity: Int
    let wind: String
    let feelsLike: Int
    let precipitation: Int
    let pressure: Double
    let visibility: Int
    let index: Int
    let street: String
}

struct HourlyWeather: Codable {
    let date: String
    let icon: String
    let temp: Int
}

struct DailyWeather: Codable {
    let day: String
    let icon: String
    let minTemp: Int
    let maxTemp: Int
}



