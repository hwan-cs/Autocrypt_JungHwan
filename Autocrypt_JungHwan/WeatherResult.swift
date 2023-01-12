//
//  WeatherResult.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation
import UIKit

struct WeatherResult: Codable, Equatable
{
    let main: MainDescription? // for temprature
    let weather: [Weather]? // for icon, description
    let sys: sys?
    let visibility: Double?
    let wind: Wind?
    var name: String?
}

extension WeatherResult
{
    static var empty: WeatherResult
    {
        return WeatherResult(main: nil, weather: nil, sys: nil, visibility: nil, wind: nil, name: nil)
    }
}
