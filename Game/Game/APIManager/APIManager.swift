//
//  APIManager.swift
//  Game
//
//  Created by Kirill on 17/12/2023.
//

import Foundation

final class APIManager {
    private let host = "172.20.10.12"
    private let port = 8080

    private init() {}
    
    static let shared = APIManager()

    func getCards(search: String = "", completion: @escaping (Result<[GameCardModel], APIError>) -> Void) {
        let urlString = "http://\(host):\(port)/api/cards"
        guard let url = URL(string: urlString) else {
            completion(.failure(.incorrectlyURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let parameters: [String: Any] = ["search": search]
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters) {
            request.httpBody = jsonData
        } else {
            completion(.failure(.badParameters))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
                return
            }
            /// Приводим `response` к типу HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.responseIsNil))
                }
                return
            }
            /// Проверяет код ответа, пришедшии с сервера
            guard (200..<300).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.badStatusCode(response.statusCode)))
                }
                return
            }
            /// Распаковка дата
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataIsNil))
                }
                return
            }
            do {
                let cards = try JSONDecoder().decode(CardsEntity.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(cards.card.mapper))
                }
                return

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
            }
        }.resume()
    }

    func getCard(uuid: String, completion: @escaping (Result<GameCardModel, APIError>) -> Void) {
        let urlString = "http://\(host):\(port)/api/cards/\(uuid)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.incorrectlyURL))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
                return
            }
            /// Приводим `response` к типу HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.responseIsNil))
                }
                return
            }
            /// Проверяет код ответа, пришедшии с сервера
            guard (200..<300).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.badStatusCode(response.statusCode)))
                }
                return
            }
            /// Распаковка дата
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataIsNil))
                }
                return
            }
            do {
                let card = try JSONDecoder().decode(GameCardEntity.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(card.mapper))
                }
                return

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
            }
        }.resume()
    }
}