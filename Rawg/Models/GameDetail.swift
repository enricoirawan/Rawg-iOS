//
//  GameDetail.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: String?
    let rating: Double
    let descriptionRaw: String

    enum CodingKeys: String, CodingKey {
        case id, name, released, rating
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
    }
}
