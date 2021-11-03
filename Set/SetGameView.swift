//
//  ContentView.swift
//  Set
//
//  Created by Kris Laratta on 9/25/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        VStack {
            Text("Set!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.orange)
            AspectVGrid(items: game.visibleCards, aspectRatio: 2/3) { card in
                cardView(for: card)
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                newGame
                Spacer()
                dealThreeCards
                Spacer()
            }
        }
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation {
                game.startNewGame()
            }
        }
        .buttonStyle(.bordered)
    }
    
    var dealThreeCards: some View {
        Button("Deal 3 Cards") {
            withAnimation {
                game.dealThreeCards()
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(game.deckIsEmpty)
    }
    
    @ViewBuilder
    private func cardView(for card: SetGameViewModel.Card) -> some View {
        let borderColor = getBorderColor(card)
        CardView(card: card)
            .padding(4)
            .onTapGesture {
                game.choose(card)
            }
            .foregroundColor(borderColor)
    }
    
    private func getBorderColor(_ card: SetGameViewModel.Card) -> Color {
        var borderColor = Color.black
        if game.cardIsMatched(cardId: card.id) {
            borderColor = Color.green
        } else if game.cardIsSelected(cardId: card.id) && game.selectedCards.count == 3 {
            borderColor = Color.red
        } else if game.cardIsSelected(cardId: card.id) {
            borderColor = Color.blue
        }
        return borderColor
    }
}

struct CardView: View {
    let card: SetGameViewModel.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
                let color: Color = SetGameViewModel.getCardColor(card.color)
                let numberOfShapes: Int = card.numberOfShapes.rawValue
                let pattern: Double = card.pattern.rawValue
                
                VStack {
                    switch card.shape {
                    case .oval:
                        ForEach(0..<numberOfShapes) {_ in
                            Capsule(style: .circular)
                                .stroke(color, lineWidth: 4)
                                .frame(maxWidth: min(geometry.size.width, geometry.size.height), maxHeight: min(geometry.size.width, geometry.size.height) / 2)
                                .overlay(
                                    Capsule(style: .circular)
                                        .fill(pattern != 0 ? color : Color.white)
                                        .opacity(pattern))
                                .frame(idealWidth: geometry.size.width, idealHeight: geometry.size.width / 3 )
                        }
                        .frame(idealWidth: geometry.size.width)
                    case .diamond:
                        ForEach(0..<numberOfShapes) {_ in
                            Diamond()
                                .stroke(color, lineWidth: 4)
                                .frame(maxWidth: min(geometry.size.width, geometry.size.height), maxHeight: min(geometry.size.width, geometry.size.height) / 2)
                                .overlay(
                                    Diamond()
                                        .fill(pattern != 0 ? color : Color.white)
                                        .opacity(pattern))
                                .frame(idealWidth: geometry.size.width, idealHeight: geometry.size.width / 3 )
                        }
                        .frame(idealWidth: geometry.size.width)
                    case .squiggle:
                        ForEach(0..<numberOfShapes) {_ in
                            Rectangle()
                                .stroke(color, lineWidth: 4)
                                .frame(maxWidth: min(geometry.size.width, geometry.size.height), maxHeight: min(geometry.size.width,geometry.size.height) / 2 )
                                .overlay(
                                    Rectangle()
                                        .fill(pattern != 0 ? color : Color.white)
                                        .opacity(pattern))
                                .frame(idealWidth: geometry.size.width, idealHeight: geometry.size.width / 3 )
                        }
                        .frame(idealWidth: geometry.size.width)
                    }
                }
                .padding(14)
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.65
    }
}



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}
