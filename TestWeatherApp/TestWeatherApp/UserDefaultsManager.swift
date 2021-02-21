//
//  UserDefaultsManager.swift
//  TestWeatherApp
//
//  Created by Pasha on 20.02.2021.
//

import Foundation

class UserDefaultsManager {
    private enum Keys: String, CaseIterable {
        case weather = "weather"
    }
    
    private let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    var weather: ForecastModel? {
        get {
            guard let value = userDefaults.value(ForecastModel.self, forKey: Keys.weather.rawValue) else { return nil }
            return value
        }
        set {
            userDefaults.set(encodable: newValue, forKey: Keys.weather.rawValue)
        }
    }
}
