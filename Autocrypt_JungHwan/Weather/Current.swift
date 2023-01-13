//
//  MainDescription.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct Current: Codable, Equatable
{
    let dt: Double
    let temp: Double
    let pressure: Double
    let humidity: Double
    let wind_speed: Double
    let wind_deg: Double
    let clouds: Int
    let weather: [Weather]
}

extension Current
{
    static var empty: Current
    {
        return Current(dt: 0.0, temp: 0.0, pressure: 0.0, humidity: 0.0, wind_speed: 0.0, wind_deg: 0.0, clouds: 0, weather: [])
    }
}
