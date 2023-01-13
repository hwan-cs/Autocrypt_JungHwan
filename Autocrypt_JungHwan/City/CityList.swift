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

extension CityList
{
    static var empty: CityList
    {
        return CityList(id: 0, name: nil, coord: nil, country: nil)
    }
}
