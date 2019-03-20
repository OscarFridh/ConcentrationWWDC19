//
//  ConcentrationGameTests.swift
//  ConcentrationGameTests
//
//  Created by Oscar Fridh on 2019-03-20.
//  Copyright © 2019 Oscar Fridh. All rights reserved.
//

import XCTest
import ConcentrationGame

class ConcentrationGameTests: XCTestCase {
    
    var sut: ConcentrationGame!
    
    override func setUp() {
        sut = ConcentrationGame(["A", "B", "C", "D", "E"])
    }
    
    // MARK: Test init
    
    func testInitCardCount() {
        XCTAssertEqual(ConcentrationGame(["A", "B", "C"]).cards.count, 6, "There should be twice as many cards as the input")
        XCTAssertEqual(ConcentrationGame(["A"]).cards.count, 2, "There should be twice as many cards as the input")
    }
    
    func testInitCardContent() {
        let game = ConcentrationGame(["A", "B", "C"])
        let content = Set(game.cards.map { $0.content })
        XCTAssertEqual(content, ["A", "B", "C"])
    }
    
    func testInitCardFileterDublicates() {
        XCTAssertEqual(ConcentrationGame(["A", "A", "A"]).cards.count, 2, "Dublicates should be removed and there should be twice as many cards as the filtered input")
    }
    
    // MARK: Test playing the game
    
    func testSelectOneCard() {
        let game = ConcentrationGame(["A", "B", "C", "D", "E"])
        let card = game.cards[0]
        
        XCTAssertFalse(card.isSelected, "The card should not be selected initially")
        game.select(card)
        XCTAssert(card.isSelected, "The card should be selected after the select function has been called")
    }
    
    func testSelectMatch() {
        let game = ConcentrationGame(["A"])
        let card1 = game.cards[0]
        let card2 = game.cards[1]
        
        // None of the card should be selected or matched initially
        XCTAssertEqual(stateForCard(card1), CardState(selected: false, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: false))
        
        // 1. Select the first card
        game.select(card1)
        
        // Now the first card should be selected, but none of the cards should be matched
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: false))
        
        // 2. Select the second card
        game.select(card2)
        
        // Now both cards should be selected and matched
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: true))
        XCTAssertEqual(stateForCard(card2), CardState(selected: true, matched: true))
    }
    
    func testSelectMismatch() {
        let game = ConcentrationGame(["A", "B"])
        let card1 = (game.cards.filter { $0.content == "A" })[0]
        let card2 = (game.cards.filter { $0.content == "B" })[0]
        
        // None of the card should be selected or matched initially
        XCTAssertEqual(stateForCard(card1), CardState(selected: false, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: false))
        
        // 1. Select the first card
        game.select(card1)
        
        // Now the first card should be selected, but none of the cards should be matched
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: false))
        
        // 2. Select the second card
        game.select(card2)
        
        // Now both cards should be selected but they should not be matched
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: true, matched: false))
    }
    
    func testSelectAfterMatch() {
        let game = ConcentrationGame(["A", "B"])
        let cards = game.cards.filter { $0.content == "A" }
        let card1 = cards[0]
        let card2 = cards[1]
        let card3 = (game.cards.filter { $0.content == "B" })[0]
        
        // 1. Make a match!
        game.select(card1)
        game.select(card2)
        
        // Test state after match
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: true))
        XCTAssertEqual(stateForCard(card2), CardState(selected: true, matched: true))
        
        // 2. Select the third card
        game.select(card3)
        
        // The first two cards should now be deselected and matched
        XCTAssertEqual(stateForCard(card1), CardState(selected: false, matched: true))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: true))
        
        // The third card should be selected but not matched
        XCTAssertEqual(stateForCard(card3), CardState(selected: true, matched: false))
    }
    
    func testSelectAfterMismatch() {
        let game = ConcentrationGame(["A", "B", "C"])
        let card1 = (game.cards.filter { $0.content == "A" })[0]
        let card2 = (game.cards.filter { $0.content == "B" })[0]
        let card3 = (game.cards.filter { $0.content == "C" })[0]
        
        // 1. Make a match!
        game.select(card1)
        game.select(card2)
        
        // Test state after match
        XCTAssertEqual(stateForCard(card1), CardState(selected: true, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: true, matched: false))
        
        // 2. Select the third card
        game.select(card3)
        
        // The first two cards should now be deselected
        XCTAssertEqual(stateForCard(card1), CardState(selected: false, matched: false))
        XCTAssertEqual(stateForCard(card2), CardState(selected: false, matched: false))
        
        // The third card should be selected but not matched
        XCTAssertEqual(stateForCard(card3), CardState(selected: true, matched: false))
    }
    
    struct CardState: Equatable {
        let selected: Bool
        let matched: Bool
    }
    
    func stateForCard(_ card: Card) -> CardState {
        return CardState(selected: card.isSelected, matched: card.hasBeenMatched)
    }
}
