//
//  ContentView.swift
//  Set
//
//  Created by Kris Laratta on 9/25/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    @Namespace private var dealingNamespace
    var body: some View {
        VStack {
            Text("Set!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.orange)
            gameBody
            .padding(.horizontal)
            HStack {
                Spacer()
                deckBody
                newGame
                discardPileBody
                Spacer()
//                dealThreeCards
//                Spacer()
            }
        }
    }
    
    @State private var dealt = Set<Int>()
    @State private var discarded = Set<Int>()
    
    private func deal(_ card: SetGameViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func discard(_ card: SetGameViewModel.Card) {
        discarded.insert(card.id)
    }
    
    private func isUndealt(_ card: SetGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func isDiscarded(_ card: SetGameViewModel.Card) -> Bool {
        discarded.contains(card.id)
    }
    
    private func isSelected(_ card: SetGameViewModel.Card) -> Bool {
        card.isSelected
    }
    
    private func dealAnimation(for card: SetGameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SetGameViewModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
                    .foregroundColor(getBorderColor(card))
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtHeight)
        .foregroundColor(Color.orange)
        .onTapGesture {
            // Deal 12 cards for a new game or else 3 when Deck is tapped
            let numberOfCards = dealt.count == 0 ? 12 : 3
            for card in game.cards.prefix(numberOfCards) {
                deal(card)
            }
        }
    }
    
    var discardPileBody: some View {
        ZStack {
            ForEach(game.cards.filter(isDiscarded)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtHeight)
        .foregroundColor(Color.black)
//        .onTapGesture {
//            // Deal 3 cards when Deck is tapped
//            for card in game.cards.prefix(3) {
//                deal(card)
//            }
//        }
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation {
                dealt = []
                discarded = []
                game.startNewGame()
            }
        }
        .buttonStyle(.bordered)
    }
    
//    var dealThreeCards: some View {
//        Button("Deal 3 Cards") {
//            withAnimation {
////                game.dealThreeCards()
//            }
//        }
//        .buttonStyle(.borderedProminent)
////        .disabled(game.deckIsEmpty)
//    }
    
    private func getBorderColor(_ card: SetGameViewModel.Card) -> Color {
        var borderColor = Color.black
        if card.isMatched {
            borderColor = Color.green
        } else if card.isSelected && game.cards.filter(isSelected).count == 3 {
            borderColor = Color.red
        } else if card.isSelected {
            borderColor = Color.blue
        }
        return borderColor
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: SetGameViewModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    
                }
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
