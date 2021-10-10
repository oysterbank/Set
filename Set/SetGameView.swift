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
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundColor(Color.orange)
            Button(action: game.startNewGame, label: {
                Text("New Game")
            })
            .padding()
            AspectVGrid(items: game.visibleCards, aspectRatio: 2/3) { card in
                cardView(for: card)
            }
            .padding(.horizontal)
            Button(action: game.dealThreeCards, label: {
                Text("Deal 3 Cards")
            })
            .padding()
        }
    }
    
    @ViewBuilder
    private func cardView(for card: SetGameViewModel.Card) -> some View {
        if card.isMatched {
            Rectangle().opacity(0)
        } else {
            let borderColor = card.isSelected ? Color.blue : Color.black
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }
                .foregroundColor(borderColor)
        }
    }
}

struct CardView: View {
    let card: SetGameViewModel.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    
                    let color: Color = SetGameViewModel.getCardColor(card.color)
                    let numberOfShapes: Int = card.numberOfShapes.rawValue
//                    let pattern = card.pattern
                    
                    VStack {
                        switch card.shape {
                        case .oval:
                            ForEach(0..<numberOfShapes) {_ in
                                Capsule()
                                    .stroke(color)
                            }
                        case .diamond:
                            ForEach(0..<numberOfShapes) {_ in
                                Diamond()
                                    .stroke(color)
                            }
                        case .squiggle:
                            ForEach(0..<numberOfShapes) {_ in
                                Rectangle()
                                    .stroke(color)
                            }
                        }
                    }.padding()
                }
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
