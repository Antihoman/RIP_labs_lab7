//
//  GameCard.swift
//  Game
//
//  Created by Kirill on 17/12/2023.
//

import SwiftUI

struct GameCard: View {
    var card: GameCardModel!
    var width: CGFloat!
    var height: CGFloat!

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: card.imageURL) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: 250)
                    .background(.gray.opacity(0.8))
            }
            .clipShape(.rect(cornerRadius: 20))
            
            Text(card.title)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.pink)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.bottom, 5)
                .frame(width: width - 10)
                .lineLimit(1)
        }
    }
}

#Preview {
    GameCard(card: .mockData, width: 200, height: 250)
}
