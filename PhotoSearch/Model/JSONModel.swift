//
//  Model.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 9/12/2022.
//

import Foundation

struct APIResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: ImgUrl
}

struct ImgUrl: Codable {
    let regular: String
}
