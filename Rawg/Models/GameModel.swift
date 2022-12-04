//
//  GameModel.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import Foundation

struct GameModel: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
}
