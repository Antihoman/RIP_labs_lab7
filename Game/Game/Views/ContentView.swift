//
//  ContentView.swift
//  Game
//
//  Created by Kirill on 17/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [GameCardModel] = []
    @State private var text = ""
    var filteredData: [GameCardModel] {
        text.isEmpty ? cards : cards.filter { $0.title.contains(text) }
    }

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                let size = proxy.size
                let spacing: CGFloat = 10
                let cardWidth = size.width / 2 - spacing * 1.5
                let columns: [GridItem] = Array(
                    repeating: GridItem(.fixed(cardWidth)),
                    count: 2
                )
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(filteredData) { card in
                            NavigationLink {
                                ContentDetailView(id: card.id)
                            } label: {
                                GameCard(card: card, width: cardWidth, height: 250)
                            }
                        }
                    }
                }
            }
            .searchable(text: $text, prompt: .defualtText)
            .onAppear {
                APIManager.shared.getCards { result in
                    switch result {
                    case .success(let cards):
                        self.cards = cards
                    case .failure(let error):
                        print(error)
                        cards = .mockData
                    }
                }
            }
            .navigationTitle("Карты")
        }
    }
}

#Preview {
    ContentView()
}


private extension Text {

    static let defualtText = Text("Поиск")
}
