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
    var hourly: [Hourly]? // for temprature
    let daily: [Daily]?
    let current: Current
}

extension WeatherResult
{
    static var empty: WeatherResult
    {
        return WeatherResult(hourly: nil, daily: nil, current: Current.empty)
    }
}
