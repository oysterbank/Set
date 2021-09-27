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
                .padding(.top)
                .foregroundColor(Color.green)
            Spacer()
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                cardView(for: card)
            }
            .foregroundColor(Color.green)
            .padding(.horizontal)
//            Spacer()
//            HStack {
//                Text("Score: \(game.score)")
//                Spacer()
//                Button(action: game.startNewGame, label: {
//                    Text("New Game")
//                })
//            }
//            .padding([.top, .leading, .trailing])
        }
    }
    
    @ViewBuilder
    private func cardView(for card: SetGameViewModel.Card) -> some View {
        CardView(card: card)
            .padding(4)
//            .onTapGesture {
//                game.choose(card)
//            }
    }
}

struct CardView: View {
    let card: SetGameViewModel.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
//                if card.isFaceUp {
//                    shape.fill().foregroundColor(.white)
//                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
//                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
//                        .padding(5).opacity(0.5)
//                    Text(card.content).font(font(in: geometry.size))
//                } else if card.isMatched {
//                    shape.opacity(0)
//                } else {
                    shape.fill()
//                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
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
