//
//  Daily.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct Daily: Codable, Equatable
{
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moonset: Double
    let moon_phase: Double
    let temp: Temp
    let weather: [Weather]
}
