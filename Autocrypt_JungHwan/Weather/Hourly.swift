//
//  Hourly.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct Hourly: Codable, Equatable
{
    let dt: Double
    let temp: Double
    let weather: [Weather]?
}
