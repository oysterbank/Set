//
//  SetGame.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import Foundation

struct SetGame<CardShape, CardColor, CardPattern, ShapeCount> where CardShape: Hashable, CardColor: Hashable, CardPattern: Hashable, ShapeCount: Hashable {
    private(set) var allCards: Array<Card>
    private(set) var deck: Set<Int>
    private(set) var discardPile: Set<Int>
    private(set) var visibleCards: Set<Int>
    private(set) var selectedCards: Set<Int>
    private(set) var matchedCards: Set<Int>
    
    mutating func choose(_ card: Card) {
        if let _ = visibleCards.firstIndex(where: { $0 == card.id })
        {
            // Is the card already selected?
            if let selectedIndex = selectedCards.firstIndex(where: { $0 == card.id }),
               selectedCards.count < 3 {
                // Deselect the card
                selectedCards.remove(at: selectedIndex)
            } else {
                
                // Are there already three 3 cards selected?
                if selectedCards.count < 4 {
                    // No, select the card.
                    selectedCards.insert(card.id)
                }
                
                // Ok, we either selected a card or already had 3 cards.
                // Either way, if we have 3 now, determine if there is a match.
                if selectedCards.count == 3, cardsAreMatched() {
                    matchedCards = selectedCards
                }
                
                if selectedCards.count == 4 {
                    if cardsAreMatched() {
                        removeMatchedCards()
                        // Select if still visible (not one of the matched cards)
                        if visibleCards.firstIndex(where: { $0 == card.id }) != nil
                        {
                            selectedCards.insert(card.id)
                        }
                        dealCards(3)
                    } else {
                        // Deselect the 3 previously selected cards and select the new one
                        selectedCards = []
                        selectedCards.insert(card.id)
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
            if let cardToAdd = deck.popFirst() {
                visibleCards.insert(cardToAdd)
            }
        }
    }
    
    mutating func removeMatchedCards() {
        // After cards are matched, they're removed from the set of visible cards.
        // This means there are also no longer any matched or selected cards.
        visibleCards.subtract(matchedCards)
        matchedCards.removeAll()
        selectedCards.removeAll()
    }
    
    func cardIsSelected(cardId: Int) -> Bool {
        selectedCards.contains(cardId)
    }
    
    func cardIsMatched(cardId: Int) -> Bool {
        matchedCards.contains(cardId)
    }
    
    func cardsAreMatched() -> Bool {
        // This method should only be called if there are at least 3 cards
        // selected, but just in case.
        if selectedCards.count < 3 {
            return false
        }
        
        let cards = allCards.filter { selectedCards.contains($0.id) }
        if colorMatch(cards) && numberOfShapeMatch(cards) && patternMatch(cards) && shapeMatch(cards) {
            return true
        }
        return false
    }
    
    private func colorMatch(_ cards: Array<Card>) -> Bool {
        let colors = Set(cards.map { $0.color })
        if colors.count == 3 {
            return true
        }
        return false
    }
    
    private func numberOfShapeMatch(_ cards: Array<Card>) -> Bool {
        let numberOfShapes = Set(cards.map { $0.numberOfShapes })
        if numberOfShapes.count == 3 {
            return true
        }
        return false
    }
    
    private func patternMatch(_ cards: Array<Card>) -> Bool {
        let patterns = Set(cards.map { $0.pattern })
        if patterns.count == 3 {
            return true
        }
        return false
    }
    
    private func shapeMatch(_ cards: Array<Card>) -> Bool {
        let shapes = Set(cards.map { $0.shape })
        if shapes.count == 3 {
            return true
        }
        return false
    }
    
    init(setCardContent: Array<(CardShape, CardColor, CardPattern, ShapeCount)>) {
        allCards = []
        deck = []
        discardPile = []
        visibleCards = []
        selectedCards = []
        matchedCards = []
        
        // Build all 81 cards and shuffle them.
        for (index, card) in setCardContent.enumerated() {
            let gameCard = Card(id: index, shape: card.0, color: card.1, pattern: card.2, numberOfShapes: card.3)
            allCards.append(gameCard)
        }
        allCards.shuffle()
        
        // Add all card ids to the deck
        deck = Set(allCards.map { $0.id })
        
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
