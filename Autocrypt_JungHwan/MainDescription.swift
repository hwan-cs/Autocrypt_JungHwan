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
    let min_temp: Double
    let max_temp: Double
}

extension MainDescription
{
    static var empty: MainDescription
    {
        return MainDescription(temp: 0.0, pressure: 0.0, humidity: 0.0, min_temp: 0.0, max_temp: 0.0)
    }
}
