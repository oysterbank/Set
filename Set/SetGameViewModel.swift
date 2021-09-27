//
//  SetGameViewModel.swift
//  Set
//
//  Created by Kris Laratta on 9/26/21.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame<SetCardContent>.Card
    
    private static func createCardContent() -> Array<SetCardContent> {
        let shapes = ["diamond", "oval", "triangle"]
        let numbersOfShapes = [1, 2, 3]
        let colors = ["red", "green", "purple"]
        let patterns = ["solid", "striped", "open"]
        
        var createdCardContents: Array<SetCardContent> = []
        
        for shape in shapes {
            for number in numbersOfShapes {
                for color in colors {
                    for pattern in patterns {
                        createdCardContents.append(
                            SetCardContent(shape: shape, numberOfShapes: number, color: color, pattern: pattern)
                        )
                    }
                }
            }
        }
        
        return createdCardContents
    }
    
    @Published private var model = SetGame<SetCardContent>(setCardContent: createCardContent())
    
    var cards: Array<Card> {
        model.cards
    }
}

struct SetCardContent: Equatable {
    var shape: String
    var numberOfShapes: Int
    var color: String
    var pattern: String
}
