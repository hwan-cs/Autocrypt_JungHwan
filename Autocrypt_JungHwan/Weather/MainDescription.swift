//
//  MainDescription.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct MainDescription: Codable, Equatable
{
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
    let feels_like: Double
}

extension MainDescription
{
    static var empty: MainDescription
    {
        return MainDescription(temp: 0.0, pressure: 0.0, humidity: 0.0, temp_min: 0.0, temp_max: 0.0, feels_like: 0.0)
    }
}
