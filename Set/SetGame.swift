//
//  SetGame.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    init(setCardContent: Array<CardContent>) {
        cards = []
        for (index, card) in setCardContent.enumerated() {
            cards.append(Card(id: index, content: card))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var id: Int
        var isSelected = false
        var isMatched = false
        let content: CardContent
    }
}
