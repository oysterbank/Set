//
//  SetGameViewModel.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    enum CardShape: CaseIterable {
        case oval, diamond, squiggle
    }
    
    enum CardColor: CaseIterable {
        case red, green, purple
    }
    
    enum CardPattern: Double, CaseIterable {
        case open = 0, solid = 1, striped = 0.5
    }
    
    enum ShapeCount: Int, CaseIterable {
        case one = 1, two, three
    }

    typealias Card = SetGame<CardShape, CardColor, CardPattern, ShapeCount>.Card
    
    private static func createCardContent() -> Array<(CardShape, CardColor, CardPattern, ShapeCount)> {
        var createdCardContents: Array<(CardShape, CardColor, CardPattern, ShapeCount)> = []
        
        for shape in CardShape.allCases {
            for number in ShapeCount.allCases {
                for color in CardColor.allCases {
                    for pattern in CardPattern.allCases {
                        createdCardContents.append((shape, color, pattern, number))
                    }
                }
            }
        }
        
        return createdCardContents
    }
    
    private static func createSetGame() -> SetGame<CardShape, CardColor, CardPattern, ShapeCount> {
        return SetGame<CardShape, CardColor, CardPattern, ShapeCount>(setCardContent: createCardContent())
    }
    
    
    @Published private var model: SetGame<CardShape, CardColor, CardPattern, ShapeCount>
    
    init() {
        self.model = SetGameViewModel.createSetGame()
    }
    
    var visibleCards: Array<Card> {
        model.visibleCards
    }
    
    static func getCardColor(_ color: CardColor) -> Color {
        switch color {
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        case .green:
            return Color.green
        }
    }
    
    func cardIsSelected(_ card: Card) -> Bool {
        model.cardIsSelected(card)
    }
    
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        self.model = SetGameViewModel.createSetGame()
    }
    
    func dealThreeCards() {
        model.dealCards(3)
    }
}
