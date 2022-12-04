//
//  Genre.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name, slug: String
    let gamesCount: Int
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
