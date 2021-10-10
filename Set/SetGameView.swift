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
//                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
//                        .padding(5).opacity(0.5)
                    
                    let cardContent = card.content
                    let numberOfShapes: Int = cardContent.numberOfShapes
                    let cardHeight: CGFloat = geometry.size.height
                    let heightMultiplyer: Double = pow(3.5, Double(numberOfShapes))
                    
                    VStack {
                        Spacer(minLength: (cardHeight / CGFloat(heightMultiplyer)))
                        ForEach(0..<numberOfShapes) {_ in
                            cardShape(cardContent.shape)
                                .font(font(in: geometry.size))
                                .foregroundColor(cardColor(cardContent.color))
                        }
                        Spacer(minLength: (cardHeight / CGFloat(heightMultiplyer)))
                    }.padding(cardHeight / 10)
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    @ViewBuilder
    private func cardShape(_ shape: String) -> some View {
        switch shape {
        case "oval":
            Capsule()
        case "diamond":
            Rectangle()
        case "triangle":
            Ellipse()
        default:
            Spacer()
        }
    }
    
    private func cardColor(_ color: String) -> Color {
        switch color {
        case "red":
            return Color.red
        case "purple":
            return Color.purple
        default:
            return Color.green
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
