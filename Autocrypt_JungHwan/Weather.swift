//
//  Weather.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation

struct Weather: Codable, Equatable
{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
