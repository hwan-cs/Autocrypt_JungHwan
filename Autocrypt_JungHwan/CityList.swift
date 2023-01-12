//
//  CityList.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct CityList: Codable, Equatable
{
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}
