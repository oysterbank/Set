//
//  SetGame.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import Foundation

struct SetGame<CardShape, CardColor, CardPattern, ShapeCount> where CardShape: Equatable, CardColor: Equatable, CardPattern: Equatable, ShapeCount: Equatable {
    private(set) var deck: Array<Card>
    private(set) var visibleCards: Array<Card>
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = visibleCards.firstIndex(where: { $0.id == card.id }),
//           !cards[chosenIndex].isFaceUp,
           !visibleCards[chosenIndex].isMatched
        {
            visibleCards[chosenIndex].isSelected.toggle()
        }
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        // TODO: check deck array length first. If array not as long as numberOfCards,
        // set numberOfCards to length of deck array
        
        // Draw cards from deck and add to our visible cards
        for _ in 0..<numberOfCards {
            if let cardToAdd = deck.popLast() {
                visibleCards.append(cardToAdd)
            }
        }
    }
    
    init(setCardContent: Array<(CardShape, CardColor, CardPattern, ShapeCount)>) {
        deck = []
        visibleCards = []
        
        // Build the deck of 81 cards and shuffle it
        for (index, card) in setCardContent.enumerated() {
            deck.append(Card(id: index, shape: card.0, color: card.1, pattern: card.2, numberOfShapes: card.3))
        }
        deck.shuffle()
        
        // Deal the first 12 cards
        dealCards(12)
    }
    
    struct Card: Identifiable {
        let id: Int
        let shape: CardShape
        let color: CardColor
        let pattern: CardPattern
        let numberOfShapes: ShapeCount
        
        var isSelected = false
        var isMatched = false
    }
}
