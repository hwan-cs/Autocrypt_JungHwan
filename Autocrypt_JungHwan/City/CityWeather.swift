//
//  CityWeather.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct CityWeather: Codable
{
    var cnt: Int?
    var list: [WeatherResult]?
}
