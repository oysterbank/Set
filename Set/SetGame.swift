//
//  SetGame.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import Foundation

struct SetGame<CardShape, CardColor, CardPattern, ShapeCount> where CardShape: Hashable, CardColor: Hashable, CardPattern: Hashable, ShapeCount: Hashable {
    private(set) var cards: Array<Card>
//    private(set) var deck: Set<Int>
//    private(set) var discardPile: Set<Int>
//    var dealt: Set<Int>
//    private(set) var selectedCards: Set<Int>
//    private(set) var matchedCards: Set<Int>
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id })
        {
            // Is the card already selected?
            if card.isSelected,
               selectedCards.count < 3 {
                // Deselect the card
                cards[chosenIndex].isSelected = false
            } else {
                
                // Are there already three 3 cards selected?
                if selectedCards.count < 4 {
                    // No, select the card.
                    cards[chosenIndex].isSelected = true
                }
                
                // Ok, we either selected a card or already had 3 cards.
                // Either way, if we have 3 now, determine if there is a match.
                if selectedCards.count == 3, cardsAreMatched() {
                    for card in selectedCards {
                        matchCard(card)
                    }
                }
                
                if selectedCards.count == 4 {
                    if cardsAreMatched() {
//                        removeMatchedCards()
                        // Select if still visible (not one of the matched cards)
                        if cards.firstIndex(where: { $0.id == card.id }) != nil
                        {
                            cards[chosenIndex].isSelected = true
                        }
//                        dealCards(3)
                    } else {
                        // Deselect the 3 previously selected cards and select the new one
                        for card in selectedCards {
                            deSelectCard(card)
                        }
                        cards[chosenIndex].isSelected = true
                    }
                }
            }
        }
    }
    
    private mutating func matchCard(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenIndex].isMatched = true
        }
    }
    
    private mutating func deSelectCard(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenIndex].isSelected = false
        }
    }
    
    private var selectedCards: Array<Card> {
        cards.filter { $0.isSelected == true }
    }
    
//    mutating func dealCards(_ numberOfCards: Int) {
//        // If there are fewer cards in the deck than numberOfCards, set
//        // cardsToDeal to the count of the deck
//        let cardsToDeal = deck.count < numberOfCards ? deck.count : numberOfCards
//
//        // Draw cards from deck and add to our visible cards
//        for _ in 0..<cardsToDeal {
//            if let cardToAdd = deck.popFirst() {
//                dealt.insert(cardToAdd)
//            }
//        }
//    }
    
//    mutating func removeMatchedCards() {
//        // After cards are matched, they're removed from the set of visible cards.
//        // This means there are also no longer any matched or selected cards.
////        dealt.subtract(matchedCards)
//        matchedCards.removeAll()
//        selectedCards.removeAll()
//    }
    
//    func cardIsSelected(cardId: Int) -> Bool {
//        selectedCards.contains(cardId)
//    }
//
//    func cardIsMatched(cardId: Int) -> Bool {
//        matchedCards.contains(cardId)
//    }
    
    func cardsAreMatched() -> Bool {
        // This method should only be called if there are at least 3 cards
        // selected, but just in case.
        if selectedCards.count < 3 {
            return false
        }
        
        if colorMatch(selectedCards) && numberOfShapeMatch(selectedCards) && patternMatch(selectedCards) && shapeMatch(selectedCards) {
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
        cards = []
//        deck = []
//        discardPile = []
//        dealt = []
//        selectedCards = []
//        matchedCards = []
        
        // Build all 81 cards and shuffle them.
        for (index, card) in setCardContent.enumerated() {
            let gameCard = Card(id: index, shape: card.0, color: card.1, pattern: card.2, numberOfShapes: card.3)
            cards.append(gameCard)
        }
        cards.shuffle()
        
        // Add all card ids to the deck
//        deck = Set(allCards.map { $0.id })
        
        // Deal the first 12 cards
//        dealCards(12)
    }
    
    struct Card: Identifiable {
        let id: Int
        var isSelected = false
        var isMatched = false
        let shape: CardShape
        let color: CardColor
        let pattern: CardPattern
        let numberOfShapes: ShapeCount
        
    }
}
