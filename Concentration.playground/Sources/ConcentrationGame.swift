//
//  ConcentrationGame.swift
//  ConcentrationGame
//
//  Created by Oscar Fridh on 2019-03-20.
//  Copyright © 2019 Oscar Fridh. All rights reserved.
//

import Foundation

public class ConcentrationGame {
    
    public let cards: [Card]
    
    public init(_ content: Set<Character>) {
        var array = [Card]()
        array += content.map { Card(content: $0) }
        array += content.map { Card(content: $0) }
        cards = array.shuffled()
    }
    
    public func select(_ card: Card) {
        
        // Deselect last match/mismatch
        if selectedCards.count == 2 {
            selectedCards.forEach { $0.isSelected = false }
        }
        
        // Select the new card
        card.isSelected = true
        
        // Mark matches
        if hasSelectedTwoMatchingCards {
            selectedCards.forEach { $0.hasBeenMatched = true }
        }
    }
    
    private var hasSelectedTwoMatchingCards: Bool {
        return selectedCards.count == 2 && Set(selectedCards.map { $0.content }).count == 1
    }
    
    private var selectedCards: [Card] {
        return cards.filter { $0.isSelected }
    }
    
}


public class Card {
    
    public let content: Character
    public fileprivate(set) var isSelected: Bool
    public fileprivate(set) var hasBeenMatched: Bool
    
    init(content: Character) {
        self.content = content
        self.isSelected = false
        self.hasBeenMatched = false
    }
    
}
