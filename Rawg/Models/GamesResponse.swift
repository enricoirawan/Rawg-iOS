//
//  GamesResponse.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import Foundation

struct GameResponse: Codable {
    let results: [GameModel]

    enum CodingKeys: String, CodingKey {
        case results
    }
}
