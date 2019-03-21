//
//  GameState.swift
//  ConcentrationGame
//
//  Created by Oscar Fridh on 2019-03-20.
//  Copyright © 2019 Oscar Fridh. All rights reserved.
//

import Foundation

public struct GameState {
    
    private var cardStates: [Card: CardState]
    
    public var cards: Set<Card> {
        return Set(cardStates.map { $0.key })
    }
    
    /// It is a programmer error to query a card that doesn't exist in the Game
    public func state(for card: Card) -> CardState {
        return cardStates[card]!
    }
    
    
    public init(_ content: Set<Character>) {
        var cardStates = [Card: CardState]()
        for character in content {
            for id in 0..<2 {
                let card = Card(id: id, content: character)
                let initialState = CardState(isSelected: false, hasBeenMatched: false)
                cardStates[card] = initialState
            }
        }
        self.init(cardStates: cardStates)
    }
    
    init(cardStates: [Card: CardState]) {
        self.cardStates = cardStates
    }
    
    public func selecting(_ card: Card) -> GameState {
        
        var newCardStates = cardStates
        
        // Deselect last match/mismatch
        if cardStates.selectedCards.count == 2 {
            for (card, state) in cardStates {
                var newState = state
                newState.isSelected = false
                newCardStates[card] = newState
            }
        }
        
        // Select the new card
        newCardStates[card]?.isSelected = true
        
        // Mark matches
        if newCardStates.hasSelectedTwoMatchingCards {
            for card in newCardStates.selectedCards {
                newCardStates[card]?.hasBeenMatched = true
            }
        }
        
        return GameState(cardStates: newCardStates)
    }
    
    public var selectedCards: Set<Card> {
        return Set(cardStates.selectedCards)
    }
    
    public var matchedCards: Set<Card> {
        return Set(cardStates.filter { $0.value.hasBeenMatched }.map { $0.key })
    }
}


/// Helper method for querying card states
private extension Dictionary where Key == Card, Value == CardState {
    
    var selectedCards: [Card] {
        return filter { $0.value.isSelected }.map { $0.key }
    }
    
    var hasSelectedTwoMatchingCards: Bool {
        return selectedCards.count == 2 && Set(selectedCards.map { $0.content }).count == 1
    }
}


/// Identifies a single card in a game of concentration
public struct Card: Hashable {
    
    private let id: Int
    let content: Character
    
    init(id: Int, content: Character) {
        self.id = id
        self.content = content
    }
    
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int {
        return "\(content.hashValue)\(id)".hashValue
    }
}


public struct CardState: Hashable {
    
    public fileprivate(set) var isSelected: Bool
    public fileprivate(set) var hasBeenMatched: Bool
    
    public static func ==(lhs: CardState, rhs: CardState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int {
        return "\(isSelected)\(hasBeenMatched)".hashValue
    }
}
