//
//  SetGame.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable {
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
    
    init(setCardContent: Array<CardContent>) {
        deck = []
        visibleCards = []
        
        // Build the deck of 81 cards and shuffle it
        for (index, card) in setCardContent.enumerated() {
            deck.append(Card(id: index, content: card))
        }
        deck.shuffle()
        
        // Deal the first 12 cards
        dealCards(12)
    }
    
    struct Card: Identifiable {
        var id: Int
        var isSelected = false
        var isMatched = false
        let content: CardContent
    }
}
