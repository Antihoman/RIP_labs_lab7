//
//  Game.swift
//  Game
//
//  Created by Kirill on 17/12/2023.
//

import Foundation

struct CardsEntity: Decodable {
    let card: [GameCardEntity]
}

struct GameCardEntity: Decodable {
    let uuid: String
    let image_url: String
    let type: String
    let name: String
    let description: String
}

struct GameCardModel: Identifiable {
    let id: String
    let title: String
    let imageURL: URL?
    let phase: String
    let description: String
}

// MARK: - Mapper

extension GameCardEntity {

    var mapper: GameCardModel {
        GameCardModel(
            id: uuid,
            title: name,
            imageURL: (image_url.replacingOccurrences(of: "localhost", with: "172.20.10.12")).toURL,
            phase: type,
            description: description
        )
    }
}

extension [GameCardEntity] {

    var mapper: [GameCardModel] {
        self.map { $0.mapper }
    }
}

// MARK: - Mock Data

extension [GameCardModel] {

    static let mockData: [GameCardModel] = (1...20).map {
        GameCardModel(
            id: "\($0)",
            title: "Теплокровность \($0)",
            imageURL: .mockData,
            phase: "Развитие \($0)",
            description: "Данное животное может быть съедено только большим хищником \($0)"
        )
    }
}

extension GameCardModel {

    static let mockData = GameCardModel(
        id: "0",
        title: "Теплокровность",
        imageURL: .mockData,
        phase: "Развитие",
        description: "Нету описания"
    )
}

extension String {

    var toURL: URL? { URL(string: self) }
}

extension URL {

    static let mockData = URL(string: "https://pibig.info/uploads/posts/2021-05/1619887055_3-pibig_info-p-anime-arti-devushek-s-belimi-volosami-anim-3.jpg")
}
