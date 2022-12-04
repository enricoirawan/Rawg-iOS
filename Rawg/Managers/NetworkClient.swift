//
//  File.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.rawg.io/api/games"
}

class NetworkClient {
    static let shared = NetworkClient()

    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Rawg-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Rawg-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Rawg-Info.plist'.")
        }
        return value
      }
    }

    func getPopularGames() async throws -> [GameModel] {
        var components = URLComponents(string: Constants.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "page_size", value: "10")
        ]
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)
        return result.results
    }

    func getRecommendedGames() async throws -> [GameModel] {
        var components = URLComponents(string: Constants.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "2"),
            URLQueryItem(name: "page_size", value: "10")
        ]

        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)

        return result.results
    }

    func getOtherGames() async throws -> [GameModel] {
        var components = URLComponents(string: Constants.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "3"),
            URLQueryItem(name: "page_size", value: "10")
        ]

        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)

        return result.results
    }

    func searchGames(with keyword: String) async throws -> [GameModel] {
        var components = URLComponents(string: Constants.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "page_size", value: "10"),
            URLQueryItem(name: "search", value: keyword)
        ]

        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)

        return result.results
    }

    func getDetailGame(with id: Int) async throws -> GameDetail {
        var components = URLComponents(string: "\(Constants.baseURL)/\(id)")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]

        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameDetail.self, from: data)

        return result
    }
}
