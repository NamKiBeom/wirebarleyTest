//
//  Response.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation

struct Response<item: Codable>: Codable {
    let quotes: item
}
