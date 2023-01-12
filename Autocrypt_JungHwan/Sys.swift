//
//  ETC.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct sys: Codable, Equatable
{
    let timezone: Int?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}
