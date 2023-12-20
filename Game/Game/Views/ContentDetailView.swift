//
//  ContentDetailView.swift
//  Game
//
//  Created by Kirill on 17/12/2023.
//

import SwiftUI

struct ContentDetailView: View {
    @State private var card: GameCardModel? = nil
    var id: String
    var body: some View {
        VStack {
            if let card {
                MainView(card: card)
            } else {
                MockView
            }
        }
        .onAppear(perform: FetchData)
        .ignoresSafeArea()
    }
}

// MARK: - Private Subviews

private extension ContentDetailView {

    var MockView: some View {
        VStack {
            Image("brann")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)

            ProgressView()
                .padding(.top, 20)
        }
    }

    var MockImageView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, minHeight: 500)
            .background(.gray.opacity(0.8))
    }

    func MainView(card: GameCardModel) -> some View {
        ScrollView {
            AsyncImage(url: card.imageURL) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                MockImageView
            }
            .clipShape(.rect(cornerRadius: 20))

            Text(card.title)
                .font(.title)

            Text("Тип: \(card.phase)")
                .font(.footnote)
                .foregroundStyle(.orange)

            Text(card.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .top])
        }
    }
}

// MARK: - Network

private extension ContentDetailView {

    func FetchData() {
        APIManager.shared.getCard(uuid: id) { result in
            switch result {
            case .success(let card):
                self.card = card
            case .failure(let error):
                print(error)
                card = .mockData
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentDetailView(id: "4bea0842-bcb8-416e-9a63-d89a63e978ca")
}
