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
    private(set) var selectedCards: Array<Card>
    private(set) var matchedCards: Array<Card>
    
    mutating func choose(_ card: Card) {
        if let _ = visibleCards.firstIndex(where: { $0.id == card.id })
        {
            // Is the card already selected?
            if let selectedIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
                // Deselect the card if less than 3
                if selectedCards.count < 3 {
                    selectedCards.remove(at: selectedIndex)
                }
            } else {
                // Are there already three 3 cards selected?
                if selectedCards.count < 3 {
                    // No, select the card.
                    selectedCards.append(card)
                }
                
                if selectedCards.count == 3 {
                    // Yes, determine if there is a match.
                    if cardsAreMatched() {
                        matchedCards = selectedCards
                    }
                }
            }
        }
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        // If there are fewer cards in the deck than numberOfCards, set
        // cardsToDeal to the count of the deck
        let cardsToDeal = deck.count < numberOfCards ? deck.count : numberOfCards
        
        // Draw cards from deck and add to our visible cards
        for _ in 0..<cardsToDeal {
            if let cardToAdd = deck.popLast() {
                visibleCards.append(cardToAdd)
            }
        }
    }
    
    func cardIsSelected(_ card: Card) -> Bool {
        if selectedCards.firstIndex(where: { $0.id == card.id }) != nil {
            return true
        } else {
            return false
        }
    }
    
    func cardIsMatched(_ card: Card) -> Bool {
        if matchedCards.firstIndex(where: { $0.id == card.id }) != nil {
            return true
        } else {
            return false
        }
    }
    
    func cardsAreMatched() -> Bool {
        // This method should only be called if there are at least 3 cards
        // selected, but just in case.
        if selectedCards.count < 3 {
            return false
        }
        
        // Logic for determining match based on 3 selected cards goes here
        // For now, just return true
        return true
    }
    
    init(setCardContent: Array<(CardShape, CardColor, CardPattern, ShapeCount)>) {
        deck = []
        visibleCards = []
        selectedCards = []
        matchedCards = []
        
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
    }
}
